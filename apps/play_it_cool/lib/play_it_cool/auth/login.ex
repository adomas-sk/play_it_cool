defmodule PlayItCool.Auth.Login do
  import Ecto.Query

  alias PlayItCool.{Repo, User}

  def login(%{email: email, password: password}) do
    result =
      from(u in User, where: u.email == ^String.downcase(email))
      |> Repo.one()

    case result do
      nil ->
        {:error, "User not found"}

      user ->
        case Bcrypt.verify_pass(password, user.password) do
          true ->
            token =
              Phoenix.Token.sign(
                PlayItCoolWeb.Endpoint,
                Application.fetch_env!(:play_it_cool_web, :token_secret),
                %{
                  id: user.id,
                  email: user.email,
                  lowercase_username: user.lowercase_username,
                  username: user.username
                }
              )

            {:ok, %{token: token, user: user}}

          false ->
            {:error, "Incorrect email"}
        end
    end
  end

  def login(_) do
    {:error, "Incorrect login data"}
  end
end

defmodule PlayItCool.Auth.Registration do
  alias PlayItCool.{Repo, User}

  def register(%{email: email, password: password, username: username}) do
    lowercase_username = String.downcase(username)
    hashed_password = Bcrypt.hash_pwd_salt(password)

    response =
      %User{}
      |> User.changeset(%{
        email: String.downcase(email),
        password: hashed_password,
        username: username,
        lowercase_username: lowercase_username
      })
      |> Repo.insert()

    case response do
      {:error, _changeset} ->
        {:error, "Incorrect user data"}

      success ->
        success
    end
  end

  def register(_) do
    {:error, "Incorrect user data"}
  end
end

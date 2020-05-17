defmodule PlayItCool.User do
  use Ecto.Schema

  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password, :string
    field :username, :string
    field :lowercase_username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password, :lowercase_username])
    |> validate_required([:email, :username, :password, :lowercase_username])
    |> validate_format(:email, ~r/^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/)
    |> unique_constraint(:email)
    |> unique_constraint(:lowercase_username)
    |> validate_length(:password, min: 6, max: 128)
    |> validate_length(:lowercase_username, min: 6, max: 128)
  end
end

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
  end
end

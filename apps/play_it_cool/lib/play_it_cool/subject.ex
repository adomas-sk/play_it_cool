defmodule PlayItCool.Subject do
  use Ecto.Schema

  import Ecto.Changeset

  schema "subjects" do
    field :label, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:label])
    |> validate_required([:label])
  end
end

defmodule PlayItCool.Question do
  use Ecto.Schema

  import Ecto.Changeset

  schema "users" do
    field :question, :string
    belongs_to :subject, PlayItCool.Subject,
      foreign_key: :subject_id,
      references: :id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:question, :subject_id])
    |> validate_required([:question, :subject_id])
  end
end

defmodule PlayItCool.Word do
  use Ecto.Schema

  import Ecto.Changeset

  schema "words" do
    field :word, :string

    belongs_to :subject, PlayItCool.Subject,
      foreign_key: :subject_id,
      references: :id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:word, :subject_id])
    |> validate_required([:word, :subject_id])
  end
end

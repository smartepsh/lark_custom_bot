defmodule LarkCustomBot.Cards.Text do
  use Ecto.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @primary_key false
  embedded_schema do
    field :at_all, :boolean, default: false
    field :text, :string
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:at_all, :text])
    |> validate_required([:text])
  end
end

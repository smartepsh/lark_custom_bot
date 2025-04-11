defmodule LarkCustomBot.Cards.Post do
  use Ecto.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @primary_key false
  embedded_schema do
    field :at_all, :boolean, default: false
    field :locale, Ecto.Enum, values: [:zh_cn, :en_us]
    field :title, :string

    embeds_many :content, Content, primary_key: false do
      field :tag, Ecto.Enum, values: [:text, :a]
      field :text, :string
      field :href, :string
    end
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:at_all, :locale, :title])
    |> cast_embed(:content, with: &content_changeset/2, required: true)
    |> validate_required([:locale])
  end

  defp content_changeset(struct, params) do
    struct
    |> cast(params, [:tag, :text, :href])
    |> validate_required([:tag])
    |> validate_required_by_type()
  end

  defp validate_required_by_type(%{valid?: false} = chset), do: chset

  defp validate_required_by_type(chset) do
    case get_field(chset, :tag) do
      :text -> validate_required(chset, [:text])
      :a -> validate_required(chset, [:text, :href])
    end
  end
end

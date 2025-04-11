defmodule LarkCustomBot.Cards.Card do
  use Ecto.Schema

  import Ecto.Changeset
  import PolymorphicEmbed

  @type t :: %__MODULE__{}

  @primary_key false
  embedded_schema do
    field :type, Ecto.Enum, values: [:text, :post]

    polymorphic_embeds_one :content,
      types: [text: LarkCustomBot.Cards.Text, post: LarkCustomBot.Cards.Post],
      on_type_not_found: :changeset_error,
      on_replace: :update
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, [:type])
    |> validate_required([:type])
    |> cast_content()
  end

  defp cast_content(%{valid?: false} = chset), do: chset

  defp cast_content(%{params: params} = chset) do
    case get_field(chset, :type) do
      type when type in [:text, :post] ->
        if is_map(params["content"]) do
          new_content = Map.put(params["content"], :__type__, type)
          new_params = Map.put(params, "content", new_content)

          chset
          |> cast(new_params, [])
          |> cast_polymorphic_embed(:content, required: true)
        else
          add_error(chset, :content, "content is required")
        end

      _ ->
        chset
    end
  end

  @spec load(map()) :: {:ok, t()} | {:error, any}
  def load(params) do
    {type, content} = Map.pop(params, :type)

    %{type: type, content: content}
    |> changeset()
    |> case do
      %{valid?: true} = chset -> {:ok, apply_changes(chset)}
      %{valid?: false} = chset -> {:error, errors_on(chset)}
    end
  end

  defp errors_on(chset) do
    PolymorphicEmbed.traverse_errors(chset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn
        {key, {:parameterized, {Ecto.Enum, _}}}, acc ->
          String.replace(acc, "%{#{key}}", "is invalid")

        {key, value}, acc ->
          String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end

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

  if Code.ensure_loaded?(JSON) do
    defimpl JSON.Encoder, for: __MODULE__ do
      def encode(%{at_all: at_all, text: text}, opts) do
        text =
          if at_all do
            "<at user_id=\"all\">所有人</at> #{text}"
          else
            text
          end

        JSON.encode_to_iodata!(%{text: text})
      end
    end
  end

  if Code.ensure_loaded?(Jason) do
    defimpl Jason.Encoder, for: __MODULE__ do
      def encode(%{at_all: at_all, text: text}, opts) do
        text =
          if at_all do
            "<at user_id=\"all\">所有人</at> #{text}"
          else
            text
          end

        %{text: text}
        |> Jason.Encode.map(opts)
      end
    end
  end
end

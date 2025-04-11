defmodule LarkCustomBot.Cards do
  alias LarkCustomBot.Cards.Card

  def new(card) do
    Card.load(card)
  end
end

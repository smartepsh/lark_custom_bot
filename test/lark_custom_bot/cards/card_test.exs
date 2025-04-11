defmodule LarkCustomBot.Cards.CardTest do
  use ExUnit.Case, async: true

  alias LarkCustomBot.Cards.Card

  describe "load/1" do
    test "for text" do
      assert {:ok, %Card{type: :text, content: %{text: "Hello"}}} =
               Card.load(%{type: :text, text: "Hello"})

      assert {:ok, %Card{type: :text, content: %{text: "Hello", at_all: true}}} =
               Card.load(%{type: :text, text: "Hello", at_all: true})
    end

    test "for post" do
      assert {:ok,
              %Card{
                type: :post,
                content: %{
                  title: "Hello",
                  locale: :zh_cn,
                  content: [%{tag: :text, text: "Hello"}]
                }
              }} =
               Card.load(%{
                 type: :post,
                 title: "Hello",
                 locale: :zh_cn,
                 content: [%{tag: :text, text: "Hello"}]
               })

      assert {:ok,
              %Card{
                type: :post,
                content: %{
                  title: "Hello",
                  locale: :zh_cn,
                  content: [%{tag: :text, text: "Hello"}],
                  at_all: true
                }
              }} =
               Card.load(%{
                 type: :post,
                 title: "Hello",
                 locale: :zh_cn,
                 content: [%{tag: :text, text: "Hello"}],
                 at_all: true
               })
    end

    test "for invalid params" do
      assert {:error, %{type: ["can't be blank"]}} = Card.load(%{})
      assert {:error, %{type: ["is invalid"]}} = Card.load(%{type: :unknown})
    end
  end
end

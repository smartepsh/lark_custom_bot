defmodule LarkCustomBot.Cards.CardTest do
  use ExUnit.Case, async: true

  alias LarkCustomBot.Cards.Card

  describe "for json encode (body to lark request)" do
    defp body(params) do
      with {:ok, card} <- Card.load(params) do
        card |> Jason.encode!() |> Jason.decode!()
      end
    end

    test "for text" do
      assert %{"msg_type" => "text", "content" => %{"text" => "Hello"}} =
               body(%{type: :text, text: "Hello"})

      assert %{
               "msg_type" => "text",
               "content" => %{"text" => "<at user_id=\"all\">所有人</at> Hello"}
             } =
               body(%{type: :text, text: "Hello", at_all: true})
    end

    test "for post" do
      assert %{
               "msg_type" => "post",
               "content" => %{
                 "post" => %{
                   "zh_cn" => %{
                     "title" => "Hello",
                     "content" => [[%{"tag" => "text", "text" => "Hello"}]]
                   }
                 }
               }
             } =
               body(%{
                 type: :post,
                 title: "Hello",
                 locale: :zh_cn,
                 content: [%{tag: :text, text: "Hello"}]
               })

      assert %{
               "msg_type" => "post",
               "content" => %{
                 "post" => %{
                   "zh_cn" => %{
                     "title" => "Hello",
                     "content" => [
                       [
                         %{"tag" => "at", "user_id" => "all"},
                         %{"tag" => "text", "text" => "Hello"}
                       ]
                     ]
                   }
                 }
               }
             } =
               body(%{
                 type: :post,
                 title: "Hello",
                 locale: :zh_cn,
                 content: [%{tag: :text, text: "Hello"}],
                 at_all: true
               })
    end
  end

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

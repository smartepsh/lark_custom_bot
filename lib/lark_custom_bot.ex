defmodule LarkCustomBot do
  alias LarkCustomBot.{Cards, Request}

  @spec call(url :: String.t(), secret :: String.t(), card :: map()) :: :ok | {:error, any()}
  def call(url, secret, card), do: call(card, url: url, secret: secret)

  @spec call(card :: map()) :: :ok | {:error, any()}
  @spec call(card :: map(), config :: map | keyword) :: :ok | {:error, any()}
  def call(card, config \\ config()) do
    with {:ok, card} <- Cards.new(card),
         :ok <- Request.call(card, config) do
      :ok
    end
  end

  def config do
    Application.get_all_env(:lark_custom_bot)
  end
end

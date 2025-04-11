defmodule LarkCustomBot.Request do
  require Logger

  @spec call(card :: map(), config :: map | keyword) ::
          :ok | {:error, String.t() | :lark_custom_bot_request_failed}
  def call(card, config) do
    url = Keyword.fetch!(config, :url)

    Req.new(url: url, json: card)
    |> Req.Request.prepend_request_steps(sign: &sign(&1, config))
    |> Req.post()
    |> handle_response()
  end

  defp sign(request, config) do
    signed_body = request |> Req.Request.fetch_option!(:json) |> LarkCustomBot.Auth.sign(config)
    Req.Request.merge_options(request, json: signed_body)
  end

  defp handle_response({:ok, %Req.Response{status: 200, body: body}}) do
    case body do
      %{"StatusCode" => 0} ->
        :ok

      %{"code" => _, "msg" => msg} ->
        {:error, msg}

      _ ->
        Logger.warning("Lark Custom Bot Request failed...")
        {:error, :lark_custom_bot_request_failed}
    end
  end

  defp handle_response(_) do
    Logger.warning("Lark Custom Bot Request failed...")
    {:error, :lark_custom_bot_request_failed}
  end
end

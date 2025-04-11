defmodule LarkCustomBot.Auth do
  @doc """
  Sign the payload with the secret key.

  ## Examples (Verified)

      iex> LarkCustomBot.Auth.sign(%{}, [secret: "abc"], now: ~U[2023-10-01 12:00:00.000000Z])
      %{"sign" => "hDTo1zKZQlzW6ENBKSZFSc1QMc9T+GaXK+SR5Z08cT4=", "timestamp" => "1696161600"}

  ## Options

    * `:now` - Do not use it. It is used for testing only. Default: `DateTime.utc_now()`.

  """
  def sign(payload, config, opts \\ [now: DateTime.utc_now()]) do
    secret = Keyword.fetch!(config, :secret)

    timestamp =
      opts |> Keyword.get(:now, DateTime.utc_now()) |> DateTime.to_unix() |> Integer.to_string()

    json_mod =
      cond do
        Code.ensure_loaded?(JSON) -> JSON
        Code.ensure_loaded?(Jason) -> Jason
        true -> raise "No JSON library found"
      end

    payload
    |> json_mod.encode!()
    |> json_mod.decode!()
    |> Map.merge(%{
      "timestamp" => timestamp,
      "sign" => :crypto.mac(:hmac, :sha256, "#{timestamp}\n#{secret}", "") |> Base.encode64()
    })
  end
end

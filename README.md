![Hex.pm Version](https://img.shields.io/hexpm/v/lark_custom_bot?style=plastic&link=https%3A%2F%2Fhex.pm%2Fpackages%2Flark_custom_bot)
![Hex.pm License](https://img.shields.io/hexpm/l/lark_custom_bot)

# LarkCustomBot

A simple package to send custom bot webhook message with signature to Lark.

## Installation

By adding `lark_custom_bot` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:lark_custom_bot, "~> 0.1"}
  ]
end
```

## Usage

### Caller

```elixir
LarkCustomBot.call(webhook_url, secret, card_params)

# or

LarkCustomBot.call(card, config \\ config)

# which config is a keyword list,
# or by set them in config.exs

config :lark_custom_bot,
  secret: "secret",
  url: "webhook_url"
```

### Card Params

Just simply support 2 type cards:

1. Text

```elixir
%{
  type: :text,
  text: "your text",
  at_all: "optional boolean"
}
```

2. Post

```elixir
%{
  type: :post,
  locale: "zh_cn or en_us",
  title: "optional",
  at_all: "optional boolean",
  content: [
    %{tag: "a or text", text: "your text", herf: "optional for tag - text"}
  ]
}
```

## Further More

- [ ] [Interactive lark card](https://open.feishu.cn/document/client-docs/bot-v3/add-custom-bot#5a997364)

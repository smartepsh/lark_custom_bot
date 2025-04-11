defmodule LarkCustomBot.MixProject do
  use Mix.Project

  @version "0.1.0"
  def project do
    [
      app: :lark_custom_bot,
      version: @version,
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs(),
      description: description(),
      source_url: github_url()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {LarkCustomBot.Application, []}
    ]
  end

  defp github_url do
    "https://github.com/smartepsh/lark_custom_bot"
  end

  defp description do
    "Use Lark Custom Bot to send webhook messages."
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"Github" => github_url()}
    ]
  end

  defp docs do
    [
      source_url: github_url(),
      source_ref: "v#{@version}",
      output: "docs/v#{@version}",
      extras: ["README.md", "CHANGELOG.md"]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.0"},
      {:polymorphic_embed, "~> 5.0"},
      {:jason, "~> 1.0", optional: true},
      {:req, "~> 0.5.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end

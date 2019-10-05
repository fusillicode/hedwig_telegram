defmodule HedwigTelegram.MixProject do
  use Mix.Project

  def project do
    [
      app: :hedwig_telegram,
      version: "0.1.0",
      elixir: "~> 1.9",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:hedwig, "~> 1.0"},
      {:httpoison, "~> 0.10"},
      {:plug, "~> 1.2", optional: true},
      {:plug_cowboy, "~> 1.0"},
      {:poison, "~> 3.0"}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["mos_, fusillicode"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/fusillicode/hedwig_telegram"}
    ]
  end
end

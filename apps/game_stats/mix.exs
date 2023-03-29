defmodule GameStats.MixProject do
  use Mix.Project

  def project do
    [
      app: :game_stats,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:con_cache, :logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:http_stream, "~> 1.0.0"},
      {:httpoison, "~> 1.7.0"},
      {:con_cache, "~> 0.13"},
      {:jason, "~> 1.2"}
    ]
  end
end

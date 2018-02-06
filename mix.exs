defmodule ElixirMangaDownloader.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_manga_downloader,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:floki, "~> 0.19.0"},
      {:httpoison, "~> 1.0"}
    ]
  end
end
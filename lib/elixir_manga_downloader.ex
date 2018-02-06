defmodule ElixirMangaDownloader do
  alias ElixirMangaDownloader.Downloader
  # ElixirMangaDownloader.Downloader.download

  defdelegate download(), to: Downloader
end

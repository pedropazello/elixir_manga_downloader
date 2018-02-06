defmodule ElixirMangaDownloader.Downloader do
  def download do
    "https://manga-fox.com/read-fullmetal-alchemist-manga/chapter-1"
    |>get_html
    |>find_pages_urls
    |>download_pages
    convert_pages(:pdf)
  end

  defp get_html(url) do
    %{body: body} = HTTPoison.get!(url)
    body
  end

  defp find_pages_urls(html) do
    html
    |>Floki.find(".content-area img")
    |>Enum.map(fn(page) ->
      {"img", img, _}      = page
      [_, _, {"src", src}] = img
      src
    end)
  end

  defp download_pages(urls) do
    urls
    |>Enum.with_index
    |>Enum.each(fn({url, index}) ->
      %{body: img} = HTTPoison.get!(url)
      File.write!("/opt/elixir_manga_download/manga_#{index}.jpg", img)
    end)
  end

  defp convert_pages(:pdf) do
    options = ["/opt/elixir_manga_download/manga_*.jpg", "-quality",
      "100", "/opt/elixir_manga_download/final_manga_01.pdf"]
    System.cmd("convert", options)
    # System.cmd("rm", ["-f", "/opt/elixir_manga_download/manga_*"])
    :ok
  end

  defp convert_pages(pages, :kindle) do
    :ok
  end
end

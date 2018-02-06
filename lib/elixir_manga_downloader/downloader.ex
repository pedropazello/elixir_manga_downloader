defmodule ElixirMangaDownloader.Downloader do
  def async_download(last_chapter) do
    Enum.each(1..last_chapter, fn i ->
      spawn(ElixirMangaDownloader.Downloader, :download_chapter, [i])
    end)
  end

  def download(last_chapter) do
    Enum.each(1..last_chapter, fn i ->
      download_chapter(i)
    end)
  end

  def download_chapter(chapter) do
    "https://manga-fox.com/read-fullmetal-alchemist-manga/chapter-#{chapter}"
    |> get_html
    |> find_pages_urls
    |> download_pages(chapter)

    convert_pages(chapter, :pdf)
    IO.puts("Chapter #{chapter} done")
  end

  defp get_html(url) do
    %{body: body} = HTTPoison.get!(url)
    body
  end

  defp find_pages_urls(html) do
    html
    |> Floki.find(".content-area img")
    |> Enum.map(fn page ->
      {"img", img, _} = page
      [_, _, {"src", src}] = img
      src
    end)
  end

  defp download_pages(urls, chapter) do
    urls
    |> Enum.with_index()
    |> Enum.each(fn {url, index} ->
      %{body: img} = HTTPoison.get!(url)
      File.mkdir("/opt/elixir_manga_download/#{chapter}")
      File.write!("/opt/elixir_manga_download/#{chapter}/manga_#{index}.jpg", img)
    end)
  end

  defp convert_pages(chapter, :pdf) do
    options = [
      "/opt/elixir_manga_download/#{chapter}/manga_*.jpg",
      "-quality",
      "100",
      "/opt/elixir_manga_download/final_manga_#{chapter}.pdf"
    ]

    System.cmd("convert", options)
    :ok
  end

  defp convert_pages(chapter, :kindle) do
    :ok
  end
end

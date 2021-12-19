defmodule Scraper do
  def main(url) do
    HTTPoison.start()

    pid = ScrapeSite.start_link(url)
    ScrapeSite.cast_url(pid, "/")

    {_, allUrls, _} = ScrapeSite.get_state(pid)

    Enum.map(allUrls, fn s -> ScrapeSite.cast_url(pid, s) end)

    ScrapeSite.search(pid, "h1")
  end
end

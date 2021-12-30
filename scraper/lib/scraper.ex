defmodule Scraper do
  def main(url) do
    HTTPoison.start()

    pid = ScrapeSite.start_link(url)
    ScrapeSite.cast_url(pid, "/")

    scrape_found_links(pid)
    ScrapeSite.search(pid, "h1")
  end

  def scrape_found_links(pid) do
    links = ScrapeSite.get_links(pid)

    Enum.map(links, fn s -> ScrapeSite.cast_url(pid, s) end)
  end
end

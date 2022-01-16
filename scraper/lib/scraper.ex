defmodule Scraper do
  def main(url) do
    # create GenServer
    pid = ScrapeSite.start_link()
    ScrapeSite.cast_url(pid, url)

    # Scrape all found Sub Paths
    scrape_found_links(pid, url)
    # Output all h1 Tags found in Scraped Sites
    ScrapeSite.search(pid, "h1")
  end

  def scrape_found_links(pid, url) do
    links = ScrapeSite.get_links(pid)
    # scrape all found Urls
    Enum.map(links, fn s -> ScrapeSite.cast_url(pid, s) end)
  end
end

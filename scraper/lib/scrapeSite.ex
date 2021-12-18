defmodule ScrapeSite do
  use GenServer

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  defp wasUrlsScraped({scrapedUrls, _, _}, url) do
    MapSet.member?(scrapedUrls, url)
  end

  @impl true
  def handle_cast({:url, url}, {scrapedUrls, allUrls, baseUrl}) do
    currentUrl = baseUrl <> url

    if wasUrlsScraped({scrapedUrls, allUrls, baseUrl}, currentUrl) do
      {:noreply, {scrapedUrls, allUrls, baseUrl}}
    else
      # parse request
      IO.puts(currentUrl)
      %{body: body} = HTTPoison.get!(currentUrl)
      {:ok, document} = Floki.parse_document(body)

      # filter Data
      links =
        Floki.attribute(document, "a", "href")
        |> filterUrls()

      scrapedUrls = MapSet.put(scrapedUrls, currentUrl)
      # convert into unique Values
      allUrls = MapSet.union(allUrls, MapSet.new(links))

      {:noreply, {scrapedUrls, allUrls, baseUrl}}
    end
  end

  defp filterUrls(urls) do
    Enum.filter(urls, notConatins("#"))
    |> Enum.filter(notConatins("#"))
    |> Enum.filter(notConatins("http"))
    |> Enum.filter(notConatins(".jpg"))
    |> Enum.filter(notConatins(".JPG"))
    |> Enum.filter(notConatins(".jpeg"))
    |> Enum.filter(notConatins("tel:"))
    |> Enum.filter(notConatins(".html"))
    |> Enum.filter(notConatins(".php"))
    |> Enum.filter(notConatins(".htm"))
    |> Enum.filter(notConatins("mailto"))
  end

  defp notConatins(notStr) do
    fn element -> not String.contains?(element, notStr) end
  end
end

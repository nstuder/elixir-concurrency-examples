defmodule ScrapeSite do
  use GenServer

  def start_link(baseUrl) do
    {:ok, pid} = GenServer.start_link(ScrapeSite, {%{}, MapSet.new(), baseUrl})
    pid
  end

  def search(pid, searchTerm) do
    GenServer.call(pid, {:search, searchTerm})
  end

  def get_state(pid) do
    GenServer.call(pid, :get)
  end

  def cast_url(pid, url) do
    GenServer.cast(pid, {:url, url})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:search, searchTerm}, _from, {scrapedUrls, allUrls, baseUrl}) do
    value =
      scrapedUrls
      |> Enum.map(fn {_, value} -> Floki.find(value, searchTerm) end)
      |> Enum.filter(fn value -> value != [] end)

    {:reply, value, {scrapedUrls, allUrls, baseUrl}}
  end

  @impl true
  def handle_cast({:url, url}, {scrapedUrls, allUrls, baseUrl}) do
    currentUrl = baseUrl <> url

    if Map.has_key?(scrapedUrls, currentUrl) do
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

      scrapedUrls = Map.put(scrapedUrls, currentUrl, document)
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

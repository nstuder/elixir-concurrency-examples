defmodule ScrapeSite do
  use GenServer

  # public API

  def start_link() do
    {:ok, pid} = GenServer.start_link(ScrapeSite, {%{}, MapSet.new()})
    pid
  end

  def search(pid, searchTerm) do
    GenServer.call(pid, {:search, searchTerm})
  end

  def get_state(pid) do
    GenServer.call(pid, :get)
  end

  def get_links(pid) do
    GenServer.call(pid, :links)
  end

  def cast_url(pid, url) do
    GenServer.cast(pid, {:url, url})
  end

  # GenServer handler Methodes

  @impl true
  def init(state) do
    HTTPoison.start()
    {:ok, state}
  end

  @impl true
  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call(:links, _from, state) do
    {_, allUrls} = state
    {:reply, allUrls, state}
  end

  @impl true
  def handle_call({:search, searchTerm}, _from, {scrapedUrls, allUrls}) do
    value =
      scrapedUrls
      |> Enum.map(fn {_, value} -> Floki.find(value, searchTerm) end)
      |> Enum.filter(fn value -> value != [] end)

    {:reply, value, {scrapedUrls, allUrls}}
  end

  @impl true
  def handle_cast({:url, url}, {scrapedUrls, allUrls}) do
    if Map.has_key?(scrapedUrls, url) do
      {:noreply, {scrapedUrls, allUrls}}
    else
      # parse request
      IO.puts(url)
      %{body: body} = HTTPoison.get!(url)
      {:ok, document} = Floki.parse_document(body)

      # filter Data
      links =
        Floki.attribute(document, "a", "href")
        |> filterUrls()
        |> Enum.map(fn path -> url <> path end)

      scrapedUrls = Map.put(scrapedUrls, url, document)
      # convert into unique Values
      allUrls = MapSet.union(allUrls, MapSet.new(links))

      {:noreply, {scrapedUrls, allUrls}}
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

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

  @impl true
  def handle_cast({:url, url}, state) do
    # parse request
    %{body: body} = HTTPoison.get!(url)
    {:ok, document} = Floki.parse_document(body)

    link = Floki.attribute(document, "a", "href")
    # filter Data
    link = Enum.filter(link, fn element -> not String.contains?(element, "#") end)
    link = Enum.filter(link, fn element -> not String.contains?(element, "http") end)
    link = Enum.filter(link, fn element -> not String.contains?(element, ".jpg") end)
    link = Enum.filter(link, fn element -> not String.contains?(element, ".JPG") end)
    link = Enum.filter(link, fn element -> not String.contains?(element, ".jpeg") end)
    link = Enum.filter(link, fn element -> not String.contains?(element, "tel:") end)
    link = Enum.filter(link, fn element -> not String.contains?(element, ".html") end)
    link = Enum.filter(link, fn element -> not String.contains?(element, ".php") end)
    link = Enum.filter(link, fn element -> not String.contains?(element, ".htm") end)
    link = Enum.filter(link, fn element -> not String.contains?(element, "mailto") end)

    # convert into unique Values
    newState = MapSet.union(state, MapSet.new(link))

    {:noreply, newState}
  end
end

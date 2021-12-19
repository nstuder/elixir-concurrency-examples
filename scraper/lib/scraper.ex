defmodule Scraper do
  def main(url) do
    HTTPoison.start()

    {:ok, pid} = GenServer.start_link(ScrapeSite, {%{}, MapSet.new(), url})
    GenServer.cast(pid, {:url, "/"})

    {_, allUrls, _} = GenServer.call(pid, :get)

    Enum.map(allUrls, fn s -> GenServer.cast(pid, {:url, s}) end)

    GenServer.call(pid, {:search, "h1"})
  end
end

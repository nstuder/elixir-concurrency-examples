defmodule Scraper do
  def main(url) do
    HTTPoison.start()

    {:ok, pid} = GenServer.start_link(ScrapeSite, {MapSet.new(), MapSet.new(), url})
    GenServer.cast(pid, {:url, "/"})

    {_, allUrls, _} = GenServer.call(pid, :get)

    # allUrls = Enum.map(allUrls, fn s -> url <> s end)

    Enum.map(allUrls, fn s -> GenServer.cast(pid, {:url, s}) end)

    GenServer.call(pid, :get)
  end
end

defmodule Scraper do
  def main(url) do
    HTTPoison.start()

    {:ok, pid} = GenServer.start_link(ScrapeSite, MapSet.new())
    GenServer.cast(pid, {:url, url})

    state = GenServer.call(pid, :get)

    state = Enum.map(state, fn s -> url <> s end)

    Enum.map(state, fn s -> GenServer.cast(pid, {:url, s}) end)

    GenServer.call(pid, :get)
  end
end

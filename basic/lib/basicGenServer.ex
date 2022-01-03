defmodule BasicGenServer do
  use GenServer

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:add, number}, state) do
    {:noreply, [number | state]}
  end

  def handle_call(:pop, _from, [first | state]) do
    {:reply, first, state}
  end
end

defmodule BasicGenServerClient do
  def main do
    {:ok, pid} = GenServer.start_link(BasicGenServer, [3, 4, 5])

    GenServer.cast(pid, {:add, 2})
    GenServer.cast(pid, {:add, 1})

    result = GenServer.call(pid, :pop)
    {:ok, result}
  end
end

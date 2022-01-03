defmodule BasicSupervisor do
  def main do
    children = [
      %{
        id: Divide,
        start: {Divide, :start_link, [[]]}
      }
    ]

    {:ok, _pid} = Supervisor.start_link(children, strategy: :one_for_one)
  end

  def devide(num, to) when num == to, do: :ok

  def devide(num, to) do
    IO.puts(GenServer.call(Divide, {:devide, num}))
    devide(num - 1, to)
  end
end

defmodule Divide do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call({:devide, number}, _from, state) do
    {:reply, 100 / number, state}
  end
end

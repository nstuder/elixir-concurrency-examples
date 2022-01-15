defmodule BasicSupervisor do
  def main do
    children = [
      %{
        id: Divide,
        start: {Divide, :start_link, [[]]}
      }
    ]

    # start Supervisor
    {:ok, _pid} = Supervisor.start_link(children, strategy: :one_for_one)

    # divide 100 through every nummer in range 10 to -10
    divide(10, -10)

    # Superviser should restart GenServer after ArithmeticError
  end

  def divide(num, to) when num == to, do: :ok

  def divide(num, to) do
    IO.puts(GenServer.call(Divide, {:divide, num}))
    divide(num - 1, to)
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

  def handle_call({:divide, number}, _from, state) do
    {:reply, 100 / number, state}
  end
end

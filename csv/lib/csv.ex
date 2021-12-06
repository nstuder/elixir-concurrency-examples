defmodule Csv do
  def main do
    {:ok, lineAgent} = Agent.start_link(fn -> [] end)

    line_pids =
      File.stream!("./lib/test.csv")
      |> Stream.map(fn line -> spawn(Csv, :map_to_list, [line, self()]) end)
      |> Enum.to_list()

    receive_from_process(lineAgent, length(line_pids))

    Agent.get(lineAgent, fn state -> IO.puts(inspect(state)) end)
  end

  def receive_from_process(_, 0) do
    :finsih
  end

  def receive_from_process(agent, process_count) do
    receive do
      {:ok, value} -> Agent.update(agent, fn state -> state ++ [value] end)
    end

    receive_from_process(agent, process_count - 1)
  end

  def map_to_list(line, parent) do
    # remove newline
    line = String.slice(line, 0..-2)
    # split into List
    list = String.split(line, ",")
    # map to Integer
    intList = Enum.map(list, fn e -> String.to_integer(e) end)
    task = Task.async(Csv, :map_square, [intList])
    # send result to parent
    send(parent, {:ok, Task.await(task)})
  end

  def map_square(lines) do
    Enum.map(lines, fn number ->
      Integer.pow(2, number)
    end)
  end
end

defmodule Sort do

  def main do
    number_of_elements = 50000000
    max_number = 1000000000

    IO.puts("generate Random Numbers")
    rand_list = 1..number_of_elements
      |> Enum.map(fn _ -> Enum.random(1..max_number) end)

    # without Tasks
    IO.puts("start sorting without Tasks:")
    {time, result} = :timer.tc(Sort, :sort, [rand_list, 2])
    IO.puts("Time: #{time}ns Lenght: #{length(result)}")

    # with Tasks
    IO.puts("start sorting with Tasks:")
    {time, result} = :timer.tc(Sort, :sort_with_tasks, [rand_list, 2])
    IO.puts("Time: #{time}ns Lenght: #{length(result)}")

  end

  def sort(data, index) when index == 0, do: Enum.sort(data)
  def sort(data, index) do
    # split in to halfs
    {left_half, right_half} = Enum.split(data, div(length(data), 2))

    # sort both halfs
    sorted_left = sort(left_half, index - 1)
    sorted_right = sort(right_half, index - 1)

    # merge lists
    :lists.merge(sorted_left, sorted_right)
  end

  def sort_with_tasks(data, index) when index == 0, do: Enum.sort(data)
  def sort_with_tasks(data, index) do
    # split in to halfs
    {left_half, right_half} = Enum.split(data, div(length(data), 2))

    # sort both halfs in Task
    left_task = Task.async(Sort, :sort_with_tasks, [left_half, index - 1])
    right_task = Task.async(Sort, :sort_with_tasks, [right_half, index - 1])

    # merge lists
    :lists.merge(Task.await(left_task, 100000), Task.await(right_task, 100000))
  end
end

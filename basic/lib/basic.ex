defmodule Basic do
  def main do
    # spawn Process anonymous Function
    pid = spawn(fn -> IO.puts("Hello World from Process") end)
    Process.info(pid)

    # spawn Process with named Function
    pid = spawn(Basic, :greet, [])

    # send Messages to Process
    send(pid, {:german, "Niklas"})
    send(pid, {:english, "Niklas"})
    send(pid, {:french, "Niklas"})
  end

  def greet do
    receive do
      {:german, name} -> IO.puts("Guten Tag #{name}")
      {:english, name} -> IO.puts("Hello #{name}")
      {_, name} -> IO.puts("Unknown Language: Name: #{name}")
    end

    # loop
    greet()
  end
end

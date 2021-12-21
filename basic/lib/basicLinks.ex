defmodule BasicLinks do
  def main do
    # spawn Process
    # pid = spawn(BasicLinks, :loop, [])

    # spawn Process with Monitor
    {pid, _} = spawn_monitor(BasicLinks, :loop, [])

    # spawn Process with Link
    # pid = spawn_link(BasicLinks, :loop, [])

    # send Messages to Process
    send(pid, {:destroy, "bad Request"})

    receive do
      {:EXIT, _from_pid, reason} -> IO.puts("Exit reason(Link): #{reason}")
      {:DOWN, _ref, :process, _from_pid, reason} -> IO.puts("Exit reason(Monitor): #{reason}")
    end

    # should only be executed if spawn monitor
    IO.puts("after Process died")
  end

  def loop do
    receive do
      {:destroy, value} -> exit("Process destroyed: #{value}")
      {:print, value} -> IO.puts(value)
      {_, _} -> :ok
    end

    # loop
    loop()
  end
end

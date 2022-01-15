# Basic Examples

This project includes four Examples how to use Concurrency in Elixir.

### compile & run

```bash
mix compile
iex -S mix
```


## Processes

Simple Example how to use processes in Elixir. Demonstrate how to create processes with `spawn()` and how to send Messages between processes with `send()` and `receive do ... end`.

### run
```elixir
Basic.main()
```


## Links

Demonstrate how Process Linking works. Comment two of the lines with `spawn()`, `spawn_link()`, or `spawn_monitor()` out. The last Code Line should only be executed if spawn monitor was called. If Links was used the Process stops before the Line is reached. If the normal `spawn()` Function is used, the Process waits for an exit Message.

### run

```elixir
BasicLinks.main()
```


## Supervisor

In this Example an Supervisor starts a GenServer that divides 100 through a given Number. If the GenServer gets a bad Parameter (0) an Error is raised and the GenServer crashes. The Supervisor should restart the Process an you can call the Function as often as you want.

### run

```elixir
BasicSupervisor.main() # start Supervisor and execute Error Function

BasicSupervisor.divide(10, 0) # Should be executed because Supervisor restarted the GenServer
```

## GenServer

This Example demonstrates how to use the GenServer API. The GenServer is implementing a Simple List.

### run
```elixir
BasicGenServer.main()
```








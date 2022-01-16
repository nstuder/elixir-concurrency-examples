# Csv Parser

This Project uses Processes and Agents to parse a csv File.

At First the File is converted in an Stream of Lines. For every Line a Process is started that parses the Line. After Parsing the Process sends it Result back to the Parent Process and append the Result to an Agent State. In the End the State of the Agent is printed to the Console.

### compile 

```bash
mix compile
iex -S mix
```

### run
```elixir
Csv.main()
```
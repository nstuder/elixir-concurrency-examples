# Web Scraper

Simpe Web Scraper that uses GenServers. 

### install 

The Project has Dependencies to floki (HTML parser) and to HTTP Poisen an HTTP Client. To install it run:

```bash
mix deps.get
```

### compile 

```bash
mix compile
iex -S mix
```

### run

The Demo Main File will Scrape a specific URL and search all URLs in the HTML File. The it will also scrape all found URLs. 

```elixir
Scraper.main(<URL>)
```
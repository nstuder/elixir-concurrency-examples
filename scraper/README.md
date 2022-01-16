# Web Scraper

Simple Web Scraper using GenServers. 

The GenServer has a public API to Scrape Sites:

| Method | Description |
|--------|-------------|
| start_link() | start the Server |
| cast_url() | cast an URL to scrape |
| search() | search a HTML Tag in scraped Websites |
| get_state() | returns the state |
| get_links() | get all Found Hyperlinks (filtered) |


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

### run Demo

The Demo Main File will Scrape a specific URL and search all URLs in the HTML File. The it will also scrape all found URLs. At the End all h1 Tags are printed to the Console

```elixir
Scraper.main(<URL>)
```
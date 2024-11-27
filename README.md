# Socrata

An application to sync weather data with Socrata.

## Approach

- find and fetch the  latest record from Socrata
- check for newer records in the DB
- send the new records to socrata
- if the new record sampled_at date is earlier than the latest record in socrata, update the record in socrata
    - find the old record with the row id
    - use the row id to update the record in socrata


## Usage

```bash
set SOCRATA_APP_TOKEN=your_socrata_app_token
set SOCRATA_API_KEY=your_socrata_api_key
set SOCRATA_DATASET_ID=your_socrata_dataset_id
set DB_URL=your_ecto_db_url
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `socrata` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:socrata, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/socrata>.


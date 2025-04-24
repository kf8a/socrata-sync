# Socrata

An application to sync weather data with Socrata.

## Approach

- fetch the latest record from Socrata
- check for newer records in the DB
- send the new records to socrata
- if the new record sampled_at date is earlier than the latest record in socrata, update the record in socrata
    - find the old record with the row id
    - use the row id to update the record in socrata

TODO:
- check the updated_at date to determine if the record has been updated


## Setup

```bash
export SOCRATA_APP_TOKEN=your_socrata_app_token
export SOCRATA_API_KEY=your_socrata_api_key
export SOCRATA_DOMAIN=your_socrata_domain
export SOCRATA_DATASET_ID=your_socrata_dataset_id
export DB_URL=your_ecto_db_url_for the weather data

mix ecto.migrate -r 
```

## Usage

```bash
mix run --no-halt
```


Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/socrata>.


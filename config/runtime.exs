import Config

config :socrata, Socrata,
  app_token: System.fetch_env!("SOCRATA_APP_TOKEN"),
  api_key: System.fetch_env!("SOCRATA_API_KEY")

config :socrata, Datasets,
  # "https://ars-datahub.data.socrata.com/resource/8a69-vy3a.json"
  domain: System.fetch_env!("SOCRATA_DOMAIN"),
  weather_dataset_id: System.fetch_env!("SOCRATA_WEATHER_DATASET_ID"),
  yield_dataset_id: System.fetch_env!("SOCRATA_YIELD_DATASET_ID")

database_url =
  System.fetch_env!("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :socrata, Socrata.Repo,
  url: database_url,
  ssl: [verify: :verify_none]

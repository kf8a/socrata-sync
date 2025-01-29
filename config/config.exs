import Config

config :socrata, Socrata,
  socrata_app_token: System.fetch_env!("SOCRATA_APP_TOKEN"),
  socrata_api_key: System.fetch_env!("SOCRATA_API_KEY"),
  # "https://ars-datahub.data.socrata.com/resource/8a69-vy3a.json"
  socrata_domain: System.fetch_env!("SOCRATA_DOMAIN"),
  socrata_dataset_id: System.fetch_env!("SOCRATA_DATASET_ID")

database_url =
  System.fetch_env!("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :socrata, ecto_repos: [Socrata.Repo, ObanRepo]

config :socrata, ObanRepo,
  database: Path.expand("../socrata.db", Path.dirname(__ENV__.file)),
  pool_size: 5,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true

config :socrata, Socrata.Repo,
  url: database_url,
  ssl: true,
  ssl_opts: [verify: :verify_none]

config :elixir, :time_zone_database, Tz.TimeZoneDatabase

config :socrata, Oban,
  engine: Oban.Engines.Lite,
  queues: [default: 10],
  repo: ObanRepo,
  plugins: [
    {Oban.Plugins.Pruner, max_age: 60 * 60 * 24 * 7},
    {Oban.Plugins.Cron,
     crontab: [
       {"@daily", Socrata.Workers.UpdateWorker}
     ]}
  ]

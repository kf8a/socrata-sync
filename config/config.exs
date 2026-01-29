import Config

config :socrata, ecto_repos: [Socrata.Repo, ObanRepo]

config :socrata, ObanRepo,
  database: Path.expand("../socrata.db", Path.dirname(__ENV__.file)),
  pool_size: 5,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true

config :elixir, :time_zone_database, Tz.TimeZoneDatabase

config :socrata, Oban,
  engine: Oban.Engines.Lite,
  queues: [default: 10, scheduled: 10],
  repo: ObanRepo,
  plugins: [
    {Oban.Plugins.Pruner, max_age: 60 * 60 * 24 * 7},
    {Oban.Plugins.Cron,
     crontab: [
      #  {"@daily", Socrata.Workers.UpdateWorker, args: %{}},
      #  {"5 4 2 * *", Socrata.Workers.SellableProductYield, args: %{}}
     ]}
  ]

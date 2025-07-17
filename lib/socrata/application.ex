defmodule Socrata.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @duration_unit {:native, :second}

  # Define histogram buckets for duration measurements (in milliseconds)
  @buckets [10, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 30000, 60000, 120_000]

  @impl true
  def start(_type, _args) do
    children = [
      Socrata.Repo,
      {TelemetryMetricsPrometheus, [metrics: metrics(), port: 8087, host: "0.0.0.0"]},
      ObanRepo,
      {Oban, Application.fetch_env!(:socrata, Oban)}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Socrata.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp metrics,
    do: [
      Telemetry.Metrics.counter("oban.job.started.count",
        event_name: [:oban, :job, :start],
        measurement: :count,
        description: "Oban jobs fetched count",
        tags: [:prefix, :queue, :attempt],
        tag_values: &extract_job_metadata/1
      ),
      Telemetry.Metrics.distribution("oban.job.duration.millisecond",
        event_name: [:oban, :job, :stop],
        measurement: :duration,
        description: "Oban job duration",
        tags: [:prefix, :queue, :attempt, :state],
        tag_values: &extract_duration_metadata/1,
        unit: @duration_unit,
        reporter_options: [buckets: @buckets]
      ),
      Telemetry.Metrics.distribution("oban.job.queue_time.millisecond",
        event_name: [:oban, :job, :stop],
        measurement: :queue_time,
        description: "Oban job queue time",
        tags: [:prefix, :queue, :attempt, :state],
        tag_values: &extract_duration_metadata/1,
        unit: @duration_unit,
        reporter_options: [buckets: @buckets]
      ),
      Telemetry.Metrics.distribution("oban.job.exception.duration.millisecond",
        event_name: [:oban, :job, :exception],
        measurement: :duration,
        description: "Oban job exception duration",
        tags: [:prefix, :queue, :kind, :state, :reason],
        tag_values: &extract_exception_metadata/1,
        unit: @duration_unit,
        reporter_options: [buckets: @buckets]
      ),
      Telemetry.Metrics.distribution("oban.job.exception.queue_time.millisecond",
        event_name: [:oban, :job, :exception],
        measurement: :queue_time,
        description: "Oban job exception queue time",
        tags: [:prefix, :queue, :kind, :state, :reason],
        tag_values: &extract_exception_metadata/1,
        unit: @duration_unit,
        reporter_options: [buckets: @buckets]
      )
    ]

  defp extract_job_metadata(metadata), do: Map.take(metadata, [:prefix, :queue, :attempt])

  defp extract_duration_metadata(metadata),
    do: Map.take(metadata, [:prefix, :queue, :attempt, :state])

  defp extract_exception_metadata(%{reason: reason} = metadata) do
    metadata
    |> Map.take([:prefix, :queue, :kind, :state])
    |> Map.put(:reason, format_reason(reason))
  end

  defp format_reason(%Oban.CrashError{}), do: "Crash Error"
  defp format_reason(%Oban.PerformError{}), do: "Perform Error"
  defp format_reason(%Oban.TimeoutError{}), do: "Timeout Error"
  defp format_reason(_), do: "Unknown"
end

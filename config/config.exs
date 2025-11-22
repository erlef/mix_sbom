import Config

if config_env() == :test do
  config :stream_data, max_runs: 10_000
end
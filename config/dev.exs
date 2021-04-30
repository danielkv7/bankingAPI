import Config

config :bankingAPI, BankingAPI.Repo,
  username: "postgres",
  password: "postgres",
  database: "bankingapi_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :bankingAPI_web, BankingAPIWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :plug_init_mode, :runtime

config :phoenix, :stacktrace_depth, 20

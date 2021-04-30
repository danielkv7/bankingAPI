import Config

config :bankingAPI, BankingAPI.Repo,
  username: "postgres",
  password: "postgres",
  database: "bankingapi_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :bankingAPI_web, BankingAPIWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn

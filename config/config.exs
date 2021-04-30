import Config

config :bankingAPI,
  ecto_repos: [BankingAPI.Repo]

config :bankingAPI_web,
  ecto_repos: [BankingAPI.Repo],
  generators: [context_app: :bankingAPI, binary_id: true]

config :bankingAPI_web, BankingAPIWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Xt25xtp7YvTbOQZJxVmJ8K43MDhvBoyfcNEbZDplmm8Mc0FYCVkrnS+jjOdCdr+S",
  render_errors: [view: BankingAPIWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: BankingAPI.PubSub,
  live_view: [signing_salt: "KVjZAN9H"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"

defmodule BankingAPIWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :bankingAPI_web

  @session_options [
    store: :cookie,
    key: "_bankingAPI_web_key",
    signing_salt: "hZ+imCEs"
  ]

  if code_reloading? do
    plug(Phoenix.CodeReloader)
    plug(Phoenix.Ecto.CheckRepoStatus, otp_app: :bankingAPI_web)
  end

  plug(Plug.RequestId)
  plug(Plug.Telemetry, event_prefix: [:phoenix, :endpoint])

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()
  )

  plug(Plug.MethodOverride)
  plug(Plug.Head)
  plug(Plug.Session, @session_options)
  plug(BankingAPIWeb.Router)
end

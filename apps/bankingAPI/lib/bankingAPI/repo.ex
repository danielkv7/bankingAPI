defmodule BankingAPI.Repo do
  use Ecto.Repo,
    otp_app: :bankingAPI,
    adapter: Ecto.Adapters.Postgres
end

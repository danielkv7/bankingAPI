defmodule BankingAPI.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      BankingAPI.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: BankingAPI.PubSub}
      # Start a worker by calling: BankingAPI.Worker.start_link(arg)
      # {BankingAPI.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: BankingAPI.Supervisor)
  end
end

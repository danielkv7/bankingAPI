defmodule BankingAPI.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      BankingAPI.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: BankingAPI.PubSub}
      # Start a worker by calling: BankingAPI.Worker.start_link(arg)
      # {BankingAPI.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: BankingAPI.Supervisor)
  end
end

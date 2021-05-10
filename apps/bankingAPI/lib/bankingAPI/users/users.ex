defmodule BankingAPI.Users do
  @moduledoc """
  Domain public functions for users context
  """
  require Logger

  alias BankingAPI.Repo
  alias BankingAPI.Users.Inputs
  alias BankingAPI.Users.Schemas.User

  @doc """
  Given a VALID changeset it attempts to insert a new user.
  It might fail due to email unique index and we transform that return
  into an error tuple.
  """
  @spec create(Inputs.Create.t()) ::
          {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create(%Inputs.Create{} = input) do
    Logger.info("Inserting new user")

    new_account = %{amount: 1000}
    params = %{name: input.name, email: input.email, account: new_account}

    params
    |> User.changeset()
    |> Repo.insert()
    |> case do
      {:ok, user} ->
        Logger.info("User successfully inserted", email: inspect(user.email))
        {:ok, user}

      {:error, changeset} ->
        Logger.error("Error while inserting new user", error: inspect(changeset))
        {:error, changeset}
    end
  end
end

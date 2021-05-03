defmodule BankingAPI.Users do
  @moduledoc """
  Domain public functions for users context
  """

  alias BankingAPI.Users.Inputs
  alias BankingAPI.Users.Schemas.User
  alias BankingAPI.Repo

  require Logger

  @doc """
  Given a VALID changeset it attempts to insert a new user.
  It might fail due to email unique index and we transform that return
  into an error tuple.
  """
  @spec create_new_user(Inputs.Create.t()) ::
          {:ok, User.t()} | {:error, Ecto.Changeset.t() | :email_conflict}
  def create_new_user(%Inputs.Create{} = input) do
    Logger.info("Inserting new user")

    params = %{name: input.name, email: input.email}

    with %{valid?: true} = changeset <- User.changeset(params),
         {:ok, user} <- Repo.insert(changeset) do
      Logger.info("User successfully inserted. Email: #{user.email}")
      {:ok, user}
    else
      %{valid?: false} = changeset ->
        Logger.error("Error while inserting new user. Error: #{inspect(changeset)}")
        {:error, changeset}
    end
  rescue
    Ecto.ConstraintError ->
      Logger.error("Email already taken")
      {:error, :email_conflict}
  end
end

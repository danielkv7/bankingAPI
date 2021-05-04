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

      {:error, changeset} ->
        Logger.error("Error while inserting new user. Error: #{inspect(changeset)}")

        emailConflict? =
          changeset.errors
          |> Enum.any?(fn {:email, {email_error_type, _}} ->
            email_error_type == "has already been taken"
          end)

        case emailConflict? do
          true ->
            Logger.error("Email already taken")
            {:error, :email_conflict}

          _ ->
            Logger.error("Error while inserting new user. Error: #{inspect(changeset)}")
            {:error, changeset}
        end
    end
  end
end

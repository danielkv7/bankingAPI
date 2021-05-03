defmodule BankingAPIWeb.UserController do
  @moduledoc """
  Actions related to the user resource.
  """
  use BankingAPIWeb, :controller

  alias BankingAPI.Users
  alias BankingAPI.Users.Inputs

  alias BankingAPIWeb.InputValidation

  def create(conn, params) do
    with {:ok, input} <- InputValidation.cast_and_apply(params, Inputs.Create),
         {:ok, user} <- Users.create_new_user(input) do
      send_json(conn, 200, user)
    else
      {:error, %Ecto.Changeset{}} ->
        msg = %{type: "bad_input", description: "Invalid input"}
        send_json(conn, 400, msg)

      {:error, :email_conflict} ->
        msg = %{type: "conflict", description: "Email already taken"}
        send_json(conn, 412, msg)
    end
  end

  defp send_json(conn, status, body) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(status, Jason.encode!(body))
  end
end

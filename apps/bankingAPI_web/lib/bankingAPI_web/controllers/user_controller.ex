defmodule BankingAPIWeb.UserController do
  @moduledoc """
  Actions related to the user resource.
  """
  use BankingAPIWeb, :controller

  alias BankingAPI.Users
  alias BankingAPI.Users.Inputs

  alias BankingAPIWeb.InputValidation
  alias BankingAPIWeb.UserView

  def create(conn, params) do
    with {:ok, input} <- InputValidation.cast_and_apply(params, Inputs.Create),
         {:ok, user} <- Users.create(input) do
      # send_json(conn, 200, user)
      conn
      |> put_status(200)
      |> put_view(UserView)
      |> render("show.json", %{
        user: user
      })
    else
      {:error,
       %Ecto.Changeset{
         errors: [
           email:
             {"has already been taken",
              [constraint: :unique, constraint_name: "users_email_index"]}
         ]
       }} ->
        msg = %{type: "unprocessable_entity", description: "Email already taken"}
        send_json(conn, 422, msg)

      {:error,
       %Ecto.Changeset{
         errors: [
           name:
             {"should be at least %{count} character(s)",
              [count: 3, validation: :length, kind: :min, type: :string]}
         ]
       }} ->
        msg = %{type: "length_required", description: "Name must have 3 digits or more"}
        send_json(conn, 411, msg)

      {:error,
       %Ecto.Changeset{
         errors: [
           email_confirmation: {"does not match confirmation", [validation: :confirmation]}
         ]
       }} ->
        msg = %{type: "precondition_failed", description: "E-mail confirmations does not match"}
        send_json(conn, 412, msg)

      {:error, %Ecto.Changeset{errors: [email: {"has invalid format", [validation: :format]}]}} ->
        msg = %{type: "precondition_failed", description: "E-mail has invalid format"}
        send_json(conn, 412, msg)

      {:error,
       %Ecto.Changeset{
         errors: [
           name: {"can't be blank", [validation: :required]},
           email: {"can't be blank", [validation: :required]}
         ]
       }} ->
        msg = %{type: "precondition_required", description: "Name or Email can not be blank"}
        send_json(conn, 428, msg)

      {:error, %Ecto.Changeset{}} ->
        msg = %{type: "internal_server_error", description: "Internal Server Error"}
        send_json(conn, 500, msg)
    end
  end

  defp send_json(conn, status, body) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(status, Jason.encode!(body))
  end
end

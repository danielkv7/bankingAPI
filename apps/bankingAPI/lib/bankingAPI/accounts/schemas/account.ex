defmodule BankingAPI.Accounts.Schemas.Account do
  @moduledoc """
  The entity of Account.

  1 user (id) - N accounts (FK user_id)
  """
  use Ecto.Schema

  alias BankingAPI.Users.Schemas.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    belongs_to(:user, User)
    field(:amount, :integer)

    timestamps()
  end
end

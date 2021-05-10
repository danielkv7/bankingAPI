defmodule BankingAPI.Accounts.Schemas.Account do
  @moduledoc """
  Account entity.

  1 account (FK user_id) -> 1 user (id)
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias BankingAPI.Users.Schemas.User

  @derive {Jason.Encoder, except: [:__meta__]}
  @required [:amount]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    belongs_to(:user, User)
    field(:account_number, :integer, read_after_writes: true)
    field(:amount, :integer)

    timestamps()
  end

  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, @required)
    |> validate_required(@required)
    |> validate_number(:amount, greater_than_or_equal_to: 0)
  end
end

defmodule BankingAPI.Accounts.Schemas.Account do
  @moduledoc """
  The entity of Account.

  1 user (id) - N accounts (FK user_id)
  """
  use Ecto.Schema

  import Ecto.Changeset

  @required [:user, :account_number, :amount]

  @derive {Jason.Encoder, except: [:__meta__]}

  alias BankingAPI.Users.Schemas.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    belongs_to(:user, User)
    field(:account_number, :integer)
    field(:amount, :integer)

    timestamps()
  end

  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, @required)
    |> validate_required(@required)
    |> validate_length(:account_number, min: 5, max: 5)
    |> unique_constraint(:account_number)
    |> validate_number(:amount, greater_than_or_equal_to: 0)
  end
end

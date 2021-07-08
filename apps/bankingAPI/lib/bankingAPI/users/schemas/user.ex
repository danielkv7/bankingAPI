defmodule BankingAPI.Users.Schemas.User do
  @moduledoc """
  The User
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias BankingAPI.Accounts.Schemas.Account

  @derive {Jason.Encoder, except: [:__meta__]}
  @required [:name, :email]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field(:name, :string)
    field(:email, :string)
    has_one(:account, Account)

    timestamps()
  end

  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, @required)
    |> cast_assoc(:account, with: &Account.changeset/2)
    |> validate_required(@required)
    |> validate_length(:name, min: 3)
    |> validate_format(:email, ~r/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/)
    |> unique_constraint(:email)
  end
end

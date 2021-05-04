defmodule BankingAPI.Users.Schemas.User do
  @moduledoc """
  The user of an account
  """
  use Ecto.Schema

  import Ecto.Changeset

  @required [:name, :email]

  @derive {Jason.Encoder, except: [:__meta__]}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field(:name, :string)
    field(:email, :string)

    timestamps()
  end

  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, @required)
    |> validate_required(@required)
    |> validate_length(:name, min: 3)
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+\-+']+@[A-Za-z0-9\.\-]+\.[A-Za-z]{2,4}$/)
    |> unique_constraint(:email)
  end
end

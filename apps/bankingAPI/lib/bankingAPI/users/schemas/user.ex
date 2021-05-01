defmodule BankingAPI.Users.Schemas.User do
  @moduledoc """
  The author of a post
  """
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field(:name, :string)
    field(:email, :string)

    timestamps()
  end
end

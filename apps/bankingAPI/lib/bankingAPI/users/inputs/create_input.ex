defmodule BankingAPI.Users.Inputs.Create do
  @moduledoc """
  Input data for calling create/1.
  """
  use Ecto.Schema

  import Ecto.Changeset

  @required [:name, :email]

  @primary_key false
  embedded_schema do
    field(:name, :string)
    field(:email, :string)
  end

  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, @required)
    |> validate_required(@required)
    |> validate_length(:name, min: 3)
    |> validate_format(:email, ~r/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/)
    |> validate_confirmation(:email)
  end
end

defmodule BankingAPI.Users.Inputs.Create do
  @moduledoc """
  Input data for calling insert_new_user/1.
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
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+\-+']+@[A-Za-z0-9\.\-]+\.[A-Za-z]{2,4}$/)
    |> validate_confirmation(:email)
  end
end

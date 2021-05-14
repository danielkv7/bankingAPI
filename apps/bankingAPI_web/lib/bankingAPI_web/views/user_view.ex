defmodule BankingAPIWeb.UserView do
  @moduledoc """
  User view
  """
  use BankingAPIWeb, :view

  def render("show.json", %{user: user}) do
    %{
      name: user.name,
      email: user.email,
      account: %{account_number: user.account.account_number, amount: user.account.amount}
    }
  end
end

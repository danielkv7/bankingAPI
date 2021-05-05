defmodule BankingAPI.UsersTest do
  use BankingAPI.DataCase

  alias BankingAPI.Users
  alias BankingAPI.Users.Inputs
  alias BankingAPI.Users.Schemas.User

  describe "create/1" do
    @tag capture_log: true
    test "fail if email is already taken" do
      email = "taken@email.com"
      Repo.insert!(%User{email: email})

      assert {:error, :email_conflict} ==
               Users.create(%Inputs.Create{name: "abc", email: email})
    end

    test "successfully create an user with valid input" do
      email = "#{Ecto.UUID.generate()}@email.com"

      assert {:ok, %User{name: "random name", email: ^email, inserted_at: %NaiveDateTime{}, updated_at: %NaiveDateTime{}} = user} =
               Users.create(%Inputs.Create{
                 name: "random name",
                 email: email
               })

      assert user == Repo.get_by(User, email: email)
    end
  end
end

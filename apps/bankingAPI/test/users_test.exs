defmodule BankingAPI.UsersTest do
  use BankingAPI.DataCase

  alias BankingAPI.Users
  alias BankingAPI.Users.Inputs
  alias BankingAPI.Users.Schemas.User

  describe "create_new_author/1" do
    @tag capture_log: true
    test "fail if email is already taken" do
      email = "taken@email.com"
      Repo.insert!(%User{email: email})

      assert {:error, :email_conflict} ==
               Users.create_new_user(%Inputs.Create{name: "abc", email: email})
    end

    test "successfully create an user with valid input" do
      email = "#{Ecto.UUID.generate()}@email.com"

      assert {:ok, user} =
               Users.create_new_user(%Inputs.Create{
                 name: "random name",
                 email: email
               })

      assert user.name == "random name"
      assert user.email == email

      query = from(a in User, where: a.email == ^email)

      assert [^user] = Repo.all(query)
    end
  end
end

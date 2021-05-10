defmodule BankingAPI.UsersTest do
  use BankingAPI.DataCase

  alias BankingAPI.Users
  alias BankingAPI.Users.Inputs
  alias BankingAPI.Users.Schemas.User

  describe "create/1" do
    test "successfully create an user and account (with amount 1000) using valid input" do
      email = "#{Ecto.UUID.generate()}@email.com"
      name = "abc"

      create_input = %Inputs.Create{
        name: name,
        email: email
      }

      assert {:ok,
              %User{
                id: user_id,
                name: ^name,
                email: ^email,
                inserted_at: %NaiveDateTime{},
                updated_at: %NaiveDateTime{},
                account: %{amount: 1000}
              } = expected_user} = Users.create(create_input)

      assert expected_user == Repo.get(User, user_id) |> Repo.preload(:account)

      assert [expected_user] == Repo.all(User) |> Repo.preload(:account)
    end

    @tag capture_log: true
    test "fail if try to create user with empty name" do
      email = "#{Ecto.UUID.generate()}@email.com"
      name = ""

      create_input = %Inputs.Create{
        name: name,
        email: email
      }

      assert {:error,
              %{valid?: false, errors: [name: {"can't be blank", [validation: :required]}]}} =
               Users.create(create_input)

      assert [] == Repo.all(User)
    end

    @tag capture_log: true
    test "fail if try to create user with empty email" do
      email = ""
      name = "abc"

      create_input = %Inputs.Create{
        name: name,
        email: email
      }

      assert {:error,
              %{valid?: false, errors: [email: {"can't be blank", [validation: :required]}]}} =
               Users.create(create_input)

      assert [] == Repo.all(User)
    end

    @tag capture_log: true
    test "fail if try to create user with name having two characters" do
      email = "#{Ecto.UUID.generate()}@email.com"
      name = "ab"

      create_input = %Inputs.Create{
        name: name,
        email: email
      }

      assert {:error,
              %{
                valid?: false,
                errors: [
                  name:
                    {"should be at least %{count} character(s)",
                     [{:count, 3}, {:validation, :length}, {:kind, :min}, {:type, :string}]}
                ]
              }} = Users.create(create_input)

      assert [] == Repo.all(User)
    end

    @tag capture_log: true
    test "fail if try to create user with invalid email" do
      email = "abs.email.com"
      name = "abc"

      create_input = %Inputs.Create{
        name: name,
        email: email
      }

      assert {:error,
              %{
                valid?: false,
                errors: [email: {"has invalid format", [validation: :format]}]
              }} = Users.create(create_input)

      assert [] == Repo.all(User)
    end

    @tag capture_log: true
    test "fail if try to create 2 users with same email" do
      email = "#{Ecto.UUID.generate()}@email.com"
      name = "abc"

      create_input = %Inputs.Create{
        name: name,
        email: email
      }

      assert {:ok, first_user} = Users.create(create_input)

      assert {:error,
              %{
                valid?: false,
                errors: [
                  email:
                    {"has already been taken",
                     [constraint: :unique, constraint_name: "users_email_index"]}
                ]
              }} = Users.create(create_input)

      assert [first_user] == Repo.all(User) |> Repo.preload(:account)
    end
  end
end

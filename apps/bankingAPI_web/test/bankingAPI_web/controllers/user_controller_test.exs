defmodule BankingAPIWeb.UserControllerTest do
  use BankingAPIWeb.ConnCase, async: true

  alias BankingAPI.Repo
  alias BankingAPI.Users.Schemas.User

  describe "POST /api/users" do
    test "sucess with 200 and user created", ctx do
      input_name = "Renan infinity PR"
      input_email = "infinityPR@mail.com"

      input = %{
        "name" => input_name,
        "email" => input_email,
        "email_confirmation" => input_email
      }

      response =
        ctx.conn
        |> post("/api/users", input)
        |> json_response(200)

      assert response["name"] == input_name
      assert response["email"] == input_email

      assert [%{name: created_name, email: created_email, account: created_account}] =
               Repo.all(User) |> Repo.preload(:account)

      assert response["name"] == created_name
      assert response["email"] == created_email
      assert response["account"]["account_number"] == created_account.account_number
      assert response["account"]["amount"] == created_account.amount
    end

    test "fail with 400 when name length is lower than 3", ctx do
      input_name = "aa"
      input_email = "aa@mail.com"

      input = %{
        "name" => input_name,
        "email" => input_email,
        "email_confirmation" => input_email
      }

      reponse =
        ctx.conn
        |> post("/api/users", input)
        |> json_response(411)

      assert reponse == %{
               "description" => "Name must have 3 digits or more",
               "type" => "length_required"
             }

      assert [] == Repo.all(User)
    end

    test "fail with 412 when email_confirmation does NOT match email", ctx do
      input_name = "aabbcc"
      input_email = "aabbcc@mail.com"

      input = %{
        "name" => input_name,
        "email" => input_email,
        "email_confirmation" => "aabb@mail.com"
      }

      response =
        ctx.conn
        |> post("/api/users", input)
        |> json_response(412)

      assert response == %{
               "description" => "E-mail confirmations does not match",
               "type" => "precondition_failed"
             }

      assert [] == Repo.all(User)
    end

    test "fail with 412 when email format is invalid", ctx do
      input_name = "aabbcc"
      input_email = "aabbcc.mail.com"

      input = %{
        "name" => input_name,
        "email" => input_email,
        "email_confirmation" => input_email
      }

      response =
        ctx.conn
        |> post("/api/users", input)
        |> json_response(412)

      assert response == %{
               "description" => "E-mail has invalid format",
               "type" => "precondition_failed"
             }

      assert [] == Repo.all(User)
    end

    test "fail with 412 when email_confirmation format is invalid", ctx do
      input_name = "aabbcc"
      input_email = "aabbcc@mail.com"

      input = %{
        "name" => input_name,
        "email" => input_email,
        "email_confirmation" => "aabbcc.mail.com"
      }

      response =
        ctx.conn
        |> post("/api/users", input)
        |> json_response(412)

      assert response == %{
               "description" => "E-mail confirmations does not match",
               "type" => "precondition_failed"
             }

      assert [] == Repo.all(User)
    end

    test "fail with 428 when required fields are missing", ctx do
      input = %{}

      assert ctx.conn
             |> post("/api/users", input)
             |> json_response(428) == %{
               "description" => "Name or Email can not be blank",
               "type" => "precondition_required"
             }

      assert [] == Repo.all(User)
    end

    @tag capture_log: true
    test "fail with 422 when email is already taken", ctx do
      input_name = "aabbcc"
      input_email = "aabbcc@mail.com"

      Repo.insert!(%User{name: input_name, email: input_email})

      assert [initial_user] = Repo.all(User)

      input = %{
        "name" => input_name,
        "email" => input_email,
        "email_confirmation" => input_email
      }

      response =
        ctx.conn
        |> post("/api/users", input)
        |> json_response(422)

      assert response == %{
               "description" => "Email already taken",
               "type" => "unprocessable_entity"
             }

      assert [initial_user] == Repo.all(User)
    end
  end
end

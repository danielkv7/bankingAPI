defmodule BankingAPIWeb.UserControllerTest do
  use BankingAPIWeb.ConnCase, async: true

  alias BankingAPI.Repo
  alias BankingAPI.Users.Schemas.User

  describe "POST /api/users" do
    test "sucess with 200 and user created", ctx do
      name = "Renan infinity PR"
      email = "infinityPR@mail.com"

      input = %{
        "name" => name,
        "email" => email,
        "email_confirmation" => email
      }

      response =
        ctx.conn
        |> post("/api/users", input)
        |> json_response(200)

      assert [%{id: created_id, name: created_name, email: created_email}] = Repo.all(User)

      assert created_id == response["id"]
      assert created_name == name
      assert created_email == email
    end

    test "fail with 400 when email_confirmation does NOT match email", ctx do
      input = %{"name" => "abc", "email" => "a@a.com", "email_confirmation" => "b@a.com"}

      assert ctx.conn
             |> post("/api/users", input)
             |> json_response(400) == %{
               "description" => "Invalid input",
               "type" => "bad_input"
             }

      assert [] == Repo.all(User)
    end

    test "fail with 400 when name is too small", ctx do
      input = %{"name" => "A", "email" => "a@a.com", "email_confirmation" => "a@a.com"}

      assert ctx.conn
             |> post("/api/users", input)
             |> json_response(400) == %{
               "description" => "Invalid input",
               "type" => "bad_input"
             }

      assert [] == Repo.all(User)
    end

    test "fail with 400 when email format is invalid", ctx do
      input = %{"name" => "Abc de D", "email" => "a@@a.com", "email_confirmation" => "a@a.com"}

      assert ctx.conn
             |> post("/api/users", input)
             |> json_response(400) == %{
               "description" => "Invalid input",
               "type" => "bad_input"
             }

      assert [] == Repo.all(User)
    end

    test "fail with 400 when email_confirmation format is invalid", ctx do
      input = %{"name" => "Abc de D", "email" => "a@a.com", "email_confirmation" => "a@@a.com"}

      assert ctx.conn
             |> post("/api/users", input)
             |> json_response(400) == %{
               "description" => "Invalid input",
               "type" => "bad_input"
             }

      assert [] == Repo.all(User)
    end

    test "fail with 400 when required fields are missing", ctx do
      input = %{}

      assert ctx.conn
             |> post("/api/users", input)
             |> json_response(400) == %{
               "description" => "Invalid input",
               "type" => "bad_input"
             }

      assert [] == Repo.all(User)
    end

    @tag capture_log: true
    test "fail with 422 when email is already taken", ctx do
      email = "#{Ecto.UUID.generate()}@email.com"

      Repo.insert!(%User{email: email})

      assert [initial_user] = Repo.all(User)

      input = %{
        "name" => "Um Dois Três de Oliveira Quatro",
        "email" => email,
        "email_confirmation" => email
      }

      assert ctx.conn
             |> post("/api/users", input)
             |> json_response(422) == %{
               "description" => "Email already taken",
               "type" => "conflict"
             }

      assert [initial_user] == Repo.all(User)
    end
  end
end

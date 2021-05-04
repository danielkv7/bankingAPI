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

      assert Enum.empty?(Repo.all(User))

      response =
        ctx.conn
        |> post("/api/users", input)
        |> json_response(200)

      assert !Enum.empty?(Repo.all(User))

      created_user = Repo.get_by(User, id: response["id"])

      assert created_user.id == response["id"]
      assert created_user.name == response["name"]
      assert created_user.email == response["email"]
    end

    test "fail with 400 when email_confirmation does NOT match email", ctx do
      input = %{"name" => "abc", "email" => "a@a.com", "email_confirmation" => "b@a.com"}

      assert ctx.conn
             |> post("/api/users", input)
             |> json_response(400) == %{
               "description" => "Invalid input",
               "type" => "bad_input"
             }

      assert Enum.empty?(Repo.all(User))
    end

    test "fail with 400 when name is too small", ctx do
      input = %{"name" => "A", "email" => "a@a.com", "email_confirmation" => "a@a.com"}

      assert ctx.conn
             |> post("/api/users", input)
             |> json_response(400) == %{
               "description" => "Invalid input",
               "type" => "bad_input"
             }

      assert Enum.empty?(Repo.all(User))
    end

    test "fail with 400 when email format is invalid", ctx do
      input = %{"name" => "Abc de D", "email" => "a@@a.com", "email_confirmation" => "a@a.com"}

      assert ctx.conn
             |> post("/api/users", input)
             |> json_response(400) == %{
               "description" => "Invalid input",
               "type" => "bad_input"
             }

      assert Enum.empty?(Repo.all(User))
    end

    test "fail with 400 when email_confirmation format is invalid", ctx do
      input = %{"name" => "Abc de D", "email" => "a@a.com", "email_confirmation" => "a@@a.com"}

      assert ctx.conn
             |> post("/api/users", input)
             |> json_response(400) == %{
               "description" => "Invalid input",
               "type" => "bad_input"
             }

      assert Enum.empty?(Repo.all(User))
    end

    test "fail with 400 when required fields are missing", ctx do
      input = %{}

      assert ctx.conn
             |> post("/api/users", input)
             |> json_response(400) == %{
               "description" => "Invalid input",
               "type" => "bad_input"
             }

      assert Enum.empty?(Repo.all(User))
    end

    @tag capture_log: true
    test "fail with 422 when email is already taken", ctx do
      email = "#{Ecto.UUID.generate()}@email.com"

      assert Enum.empty?(Repo.all(User))

      Repo.insert!(%User{email: email})

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

      assert !Enum.empty?(Repo.all(User))
    end
  end
end

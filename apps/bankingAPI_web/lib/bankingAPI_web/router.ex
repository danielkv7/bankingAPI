defmodule BankingAPIWeb.Router do
  use BankingAPIWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", BankingAPIWeb do
    pipe_through(:api)

    # Create users
    post("/users", UserController, :create)
  end
end

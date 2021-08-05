defmodule TellerApiSandboxWeb.Router do
  use TellerApiSandboxWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :auth
  end

  scope "/api", TellerApiSandboxWeb do
    pipe_through :api

    get "/token", AccountsController, :token
    get "/accounts", AccountsController, :index
    # get "/accounts/:account_id"
    # get "/accounts/:account_id/transactions"
    # get "/accounts/:account_id/transactions/:transaction_id"
  end

  defp auth(conn, opts) do
    username = System.fetch_env!("TELLER_USERNAME")
    password = System.fetch_env!("TELLER_PASSWORD")
    Plug.BasicAuth.basic_auth(conn, username: username, password: password)
  end
end

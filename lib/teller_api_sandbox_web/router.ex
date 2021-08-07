defmodule TellerApiSandboxWeb.Router do
  use TellerApiSandboxWeb, :router

  alias TellerApiSandbox.Tokens

  pipeline :api do
    plug :accepts, ["json"]
    plug :auth
    plug :assign_state_from_api_token
  end

  scope "/api", TellerApiSandboxWeb do
    pipe_through :api

    get "/token", AccountController, :token
    get "/accounts", AccountController, :index
    get "/accounts/:account_id", AccountController, :show
    get "/accounts/:account_id/transactions", TransactionController, :index
    # get "/accounts/:account_id/transactions/:transaction_id"
  end

  defp auth(conn, _opts) do
    username = System.fetch_env!("TELLER_USERNAME")
    password = System.fetch_env!("TELLER_PASSWORD")
    Plug.BasicAuth.basic_auth(conn, username: username, password: password)
  end

  defp assign_state_from_api_token(conn, _opts) do
    decoded_state =
      conn
      |> get_req_header("authorization")
      |> decode_auth_header()
      |> Tokens.decode_state_from()

    conn
    |> assign(:state, decoded_state)
  end

  defp decode_auth_header(["Basic " <> base64_encoded_credentials]) do
    Base.decode64!(base64_encoded_credentials)
  end
end

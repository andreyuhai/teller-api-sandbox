defmodule TellerApiSandboxWeb.Router do
  use TellerApiSandboxWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :auth
    plug :assign_state_from_api_token
  end

  scope "/api", TellerApiSandboxWeb do
    pipe_through :api

    get "/token", AccountsController, :token
    get "/accounts", AccountsController, :index
    # get "/accounts/:account_id"
    # get "/accounts/:account_id/transactions"
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
      |> decode_api_token_from_basic_auth()

    conn
    |> assign(:state, decoded_state)
  end

  defp decode_api_token_from_basic_auth(["Basic " <> base64_credentials]) do
    {:ok, "test_" <> credentials} = Base.decode64(base64_credentials)
    [api_token, pass]= String.split(credentials, ":")
    {:ok, %{} = verified} = Plug.Crypto.verify("foo", "bar", api_token)
    verified
  end
end

defmodule TellerApiSandboxWeb.AccountController do
  use TellerApiSandboxWeb, :controller

  alias TellerApiSandbox.{Accounts, Tokens}

  def index(conn, _params) do
    json(conn, Accounts.generate_account_data(conn.assigns.state))
  end

  def show(conn, params) do
    if Accounts.valid_account_id?(conn.assigns.state, params["account_id"]) do
      json(conn, Accounts.generate_account_data(conn.assigns.state))
    else
      json(conn, %{error: "Invalid account id"})
    end
  end

  def token(conn, _params) do
    token = Tokens.generate_api_token(%{seed: :rand.uniform(200)})

    json(conn, %{token: token})
  end
end

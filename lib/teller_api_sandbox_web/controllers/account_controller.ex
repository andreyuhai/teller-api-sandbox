defmodule TellerApiSandboxWeb.AccountController do
  use TellerApiSandboxWeb, :controller

  alias TellerApiSandbox.{Accounts, Tokens}

  def index(conn, _params) do
    json(conn, Accounts.generate_account_data(conn.assigns.state))
  end

  def token(conn, _params) do
    token = Tokens.generate(%{account_id: "test_acc_E6kuc45U", rand_seed: :rand.uniform(200)})
    System.put_env("TELLER_USERNAME", token)

    json(conn, %{token: token})
  end
end

defmodule TellerApiSandboxWeb.TransactionController do
  use TellerApiSandboxWeb, :controller

  alias TellerApiSandbox.{Accounts, Transactions, Tokens}

  def index(conn, params) do
    state = conn.assigns.state

    if Accounts.valid_account_id?(state, params["account_id"]) do
      json(conn, Transactions.generate_transactions(state))
    else
      json(conn, %{error: "Invalid account id"})
    end
  end

  def show(conn, _params) do
    json(conn, Transactions.generate_transaction(conn.assigns.state))
  end
end

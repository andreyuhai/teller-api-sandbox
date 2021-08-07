defmodule TellerApiSandboxWeb.TransactionController do
  use TellerApiSandboxWeb, :controller

  alias TellerApiSandbox.{Accounts, Transactions, Tokens}

  def index(conn, params) do
    state = conn.assigns.state
    account_id = params["account_id"]

    if Accounts.valid_account_id?(state, account_id) do
      json(conn, Transactions.generate_transactions(state, account_id))
    else
      json(conn, %{error: "Invalid account id"})
    end
  end

  def show(conn, params) do
    state = conn.assigns.state
    account_id = params["account_id"]
    transaction_id = params["transaction_id"]

    if Transactions.valid_transaction_id?(transaction_id, account_id,state.seed) do
      {:ok, d} = Base.decode64(transaction_id)
      <<days_ago::binary-size(2), seed::binary>> = d
      {days_ago, ""} = Integer.parse(days_ago)

      json(conn, Transactions.generate_transaction(state.seed, account_id, days_ago))
    else
      json(conn, %{error: "Invalid transaction id"})
    end
  end
end

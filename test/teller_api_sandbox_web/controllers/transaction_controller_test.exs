defmodule TellerApiSandboxWeb.TransactionControllerTest do
  use TellerApiSandboxWeb.ConnCase
  alias TellerApiSandbox.{Accounts, Tokens, Transactions}
  alias Plug.BasicAuth

  test "/accounts/:account_id/transactions returns the same list of transactions going 90 days back every time", %{conn: conn} do
    seed = 999
    api_token = Tokens.generate_api_token(%{seed: seed})
    account = Accounts.generate_account_data(%{seed: seed})
    transactions = Transactions.generate_transactions(%{seed: seed}, account["id"])

    for _ <- 1..100 do
      response =
        conn
        |> put_req_header("authorization", BasicAuth.encode_basic_auth(api_token, ""))
        |> get(Routes.transaction_path(conn, :index, account["id"]))
        |> json_response(200)

      assert transactions == response
      assert 90 == length(transactions)
    end
  end

  test "/accounts/:account_id/transactions/:transaction_id returns the same transaction for the given transaction id every time", %{conn: conn} do
    seed = 999
    api_token = Tokens.generate_api_token(%{seed: seed})
    account = Accounts.generate_account_data(%{seed: seed})
    transactions = Transactions.generate_transactions(%{seed: seed}, account["id"])
    transaction = Enum.random(transactions)

    for _ <- 1..100 do
      response =
        conn
        |> put_req_header("authorization", BasicAuth.encode_basic_auth(api_token, ""))
        |> get(Routes.transaction_path(conn, :show, account["id"], transaction["id"]))
        |> json_response(200)

      assert transaction == response
    end
  end

  test "/accounts/:account_id/transactions/:transaction_id returns returns error given invalid transaction id", %{conn: conn} do
    seed = 999
    api_token = Tokens.generate_api_token(%{seed: seed})
    account = Accounts.generate_account_data(%{seed: seed})

    response =
      conn
      |> put_req_header("authorization", BasicAuth.encode_basic_auth(api_token, ""))
      |> get(Routes.transaction_path(conn, :show, account["id"], "invalidTransactionID"))
      |> json_response(200)

    assert %{"error" => "Invalid transaction id or account id"} == response
  end

  test "/accounts/:account_id/transactions/:transaction_id returns returns error given invalid account id", %{conn: conn} do
    seed = 999
    api_token = Tokens.generate_api_token(%{seed: seed})
    account = Accounts.generate_account_data(%{seed: seed})
    transactions = Transactions.generate_transactions(%{seed: seed}, account["id"])
    transaction = Enum.random(transactions)

    response =
      conn
      |> put_req_header("authorization", BasicAuth.encode_basic_auth(api_token, ""))
      |> get(Routes.transaction_path(conn, :show, "invalidAccountID", transaction["id"]))
      |> json_response(200)

    assert %{"error" => "Invalid transaction id or account id"} == response
  end


  test "each running balance plus the amount equals previous day's running balance", %{conn: conn} do
    seed = 999
    api_token = Tokens.generate_api_token(%{seed: seed})
    account = Accounts.generate_account_data(%{seed: seed})

    transactions =
      conn
      |> put_req_header("authorization", BasicAuth.encode_basic_auth(api_token, ""))
      |> get(Routes.transaction_path(conn, :index, account["id"]))
      |> json_response(200)

    assert true ==
      0..88
      |> Enum.all?(fn index ->
        running_balance =
          transactions
          |> Enum.at(index)
          |> Map.get("running_balance")
          |> String.to_float()

        amount =
          transactions
          |> Enum.at(index)
          |> Map.get("amount")
          |> String.to_float()

        previous_day_running_balance =
          transactions
          |> Enum.at(index + 1)
          |> Map.get("running_balance")
          |> String.to_float()

        Float.round(running_balance - amount, 2) == previous_day_running_balance
      end)
  end
end

defmodule TellerApiSandboxWeb.AccountControllerTest do
  use TellerApiSandboxWeb.ConnCase
  alias TellerApiSandbox.{Accounts, Tokens}
  alias Plug.BasicAuth

  test "/token returns a new api token", %{conn: conn} do
    response =
      conn
      |> get(Routes.account_path(conn, :token))
      |> json_response(200)

    assert %{"token" => _} = response
  end

  test "/accounts returns the same account data every time", %{conn: conn} do
    seed = 999
    api_token = Tokens.generate_api_token(%{seed: seed})
    account = Accounts.generate_account_data(%{seed: seed})

    for _ <- 1..100 do
      response =
        conn
        |> put_req_header("authorization", BasicAuth.encode_basic_auth(api_token, ""))
        |> get(Routes.account_path(conn, :index))
        |> json_response(200)

      assert account == response
    end
  end

  test "/accounts/:account_id returns the same account data every time", %{conn: conn} do
    seed = 999
    api_token = Tokens.generate_api_token(%{seed: seed})
    account = Accounts.generate_account_data(%{seed: seed})

    for _ <- 1..100 do
      response =
        conn
        |> put_req_header("authorization", BasicAuth.encode_basic_auth(api_token, ""))
        |> get(Routes.account_path(conn, :show, account["id"]))
        |> json_response(200)

      assert account == response
    end
  end

  test "/accounts/:account_id returns error upon invalid account id", %{conn: conn} do
    seed = 999
    api_token = Tokens.generate_api_token(%{seed: seed})

    response =
      conn
      |> put_req_header("authorization", BasicAuth.encode_basic_auth(api_token, ""))
      |> get(Routes.account_path(conn, :show, "invalidAccountID"))
      |> json_response(200)

    assert %{"error" => "Invalid account id"} == response
  end
end

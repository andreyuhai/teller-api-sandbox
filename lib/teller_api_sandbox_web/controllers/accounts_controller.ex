defmodule TellerApiSandboxWeb.AccountsController do
  use TellerApiSandboxWeb, :controller

  def index(conn, _params) do
    json(conn, %{name: "Burak"})
  end

  def token(conn, _params) do
    {:ok, enc} = Jason.encode(%{name: "burak", surname: "kaymakci"})
    str = "test_" <> Plug.Crypto.encrypt("foo", "bar", enc)
    System.put_env("TELLER_USERNAME", str)
    json(conn, %{token: str})
  end
end

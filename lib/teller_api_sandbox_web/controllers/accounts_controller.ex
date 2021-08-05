defmodule TellerApiSandboxWeb.AccountsController do
  use TellerApiSandboxWeb, :controller

  def index(conn, _params) do
    json(conn, %{name: "Burak"})
  end

  def token(conn, _params) do
    System.put_env("TELLER_USERNAME", "burakkaymakciaskdlmasd")
    json(conn, %{token: "burakkaymakciaskdlmasd"})
  end
end

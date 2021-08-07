defmodule TellerApiSandbox.Tokens do

  def generate_api_token(%{} = state) do
    "test_" <> Plug.Crypto.sign("foo", "bar", state)
  end

  def decode_api_token("test_" <> credentials) do
    [api_token, pass] = String.split(credentials, ":")
    {:ok, %{} = verified_state} = Plug.Crypto.verify("foo", "bar", api_token)
    verified_state
  end
end

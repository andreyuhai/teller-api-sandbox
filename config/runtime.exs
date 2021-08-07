alias TellerApiSandbox.Tokens

token = Tokens.generate_api_token(%{account_seed: :rand.uniform(200)})

System.put_env("TELLER_USERNAME", token)
System.put_env("TELLER_PASSWORD", "")

IO.inspect(token, label: "token")

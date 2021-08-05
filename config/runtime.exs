alias TellerApiSandbox.Tokens

token = Tokens.generate(%{account_id: "test_acc_E6kuc45U", random_seed: :rand.uniform(200)})

System.put_env("TELLER_USERNAME", token)
System.put_env("TELLER_PASSWORD", "")

IO.inspect(token, label: "token")

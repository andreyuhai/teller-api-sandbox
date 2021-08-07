defmodule TellerApiSandbox.Accounts do

  @institutions [
    "Chase", "Bank of America", "Wells Fargo", "Citi", "Capital One"
  ]

  def valid_account_id?(state, account_id) do
    account_data = generate_account_data(state)

    account_data.id == account_id
  end

  def generate_account_data(state) do
    :rand.seed(:exs64, state.seed)
    balances = balances()
    account_id = account_id()

    %{
      balances: balances,
      account_number: account_number(),
      currency_code: currency_code(),
      enrollment_id: enrollment_id(),
      id: account_id,
      institution: institution(),
      links: %{
        "self": "http://localhost/accounts/#{account_id}",
        transactions: "http://localhost/accounts/#{account_id}/transactions"
      },
      name: "Test Checking Account",
      routing_numbers: routing_numbers()
    }
  end

  defp account_number do
    1_000_000_000..9_999_999_999 |> Enum.random() |> to_string()
  end

  defp balances do
    balance = 100_000..999_999 |> Enum.random() |> Kernel./(100) |> to_string()

    %{
      available: balance,
      ledger: balance
    }
  end

  defp currency_code do
    currencies = ["USD", "PLN", "EUR", "GBP", "TRY"]
    Enum.random(currencies)
  end

  defp enrollment_id do
    {alg, seed} = :rand.export_seed()
    "test_enr_" <> (seed |> to_string() |> Base.encode32())
  end

  defp routing_numbers do
    %{
      ach: 100_000_000..999_999_999 |> Enum.random() |> to_string(),
      wire: 100_000_000..999_999_999 |> Enum.random() |> to_string()
    }
  end

  defp account_id do
    {alg, seed} = :rand.export_seed()
    "test_acc_" <> (seed |> to_string() |> Base.encode64())
  end

  defp institution do
    institution = Enum.random(@institutions)
    %{
      id: institution |> String.downcase() |> String.replace(~r/\s+/, "_"),
      name: institution
    }
  end
end

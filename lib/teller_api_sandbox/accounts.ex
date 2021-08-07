defmodule TellerApiSandbox.Accounts do

  def valid_account_id?(state, account_id) do
    account_data = generate_account_data(state)

    account_data.id == account_id
  end

  def generate_account_data(state) do
    :rand.seed(:exsplus, state.random_seed)

    %{
      account_number: 112233445566,
      balances: %{
        available: 1256.31,
        ledger: 1256.31
      },
      currency_code: "USD",
      enrollment_id: "test_enr_1xyG_97e",
      id: state.account_id,
      institution: %{
        id: "teller_bank",
        name: "The Teller Bank"
      },
      links: %{
        "self": "http://localhost/accounts/test_acc_E6kuc45U",
        transactions: "http://localhost/accounts/test_acc_E6kuc45U/transactions"
      },
      name: "Test Checking Account",
      routing_numbers: %{
        ach: "864952590",
        wire: "124952590"
      }
    }
  end
end

defmodule TellerApiSandbox.Transactions do


  @merchants [
    "Uber", "Uber Eats", "Lyft", "Five Guys", "In-N-Out Burger", "Chick-Fil-A", "AMC Metreon", "Apple", "Amazon", "Walmart", "Target", "Hotel Tonight", "Misson Ceviche", "The Creamery", "Caltrain", "Wingstop", "Slim Chickens", "CVS", "Duane Reade", "Walgreens", "Rooster & Rice", "McDonald's", "Burger King", "KFC", "Popeye's", "Shake Shack", "Lowe's", "The Home Depot", "Costco", "Kroger", "iTunes", "Spotify", "Best Buy", "TJ Maxx", "Aldi", "Dollar General", "Macy's", "H.E. Butt", "Dollar Tree", "Verizon Wireless", "Sprint PCS", "T-Mobile", "Kohl's", "Starbucks", "7-Eleven", "AT&T Wireless", "Rite Aid", "Nordstrom", "Ross", "Gap", "Bed, Bath & Beyond", "J.C. Penney", "Subway", "O'Reilly", "Wendy's", "Dunkin' Donuts", "Petsmart", "Dick's Sporting Goods", "Sears", "Staples", "Domino's Pizza", "Pizza Hut", "Papa John's", "IKEA", "Office Depot", "Foot Locker", "Lids", "GameStop", "Sephora", "MAC", "Panera", "Williams-Sonoma", "Saks Fifth Avenue", "Chipotle Mexican Grill", "Exxon Mobil", "Neiman Marcus", "Jack In The Box", "Sonic", "Shell"
  ]

  def valid_transaction_id?(transaction_id, account_id, seed) do
    with {:ok, decoded_transaction_id} <- Base.decode64(transaction_id),
         <<days_ago::binary-size(2), rest::binary>> <- decoded_transaction_id,
         {days_ago, ""} <- Integer.parse(days_ago),
         {_, ""} <- Integer.parse(rest) do

      transaction = generate_transaction(seed, account_id, days_ago)
      transaction.id == transaction_id
    else
      _ -> false
    end
  end

  def generate_transactions(state, account_id) do
    1..90
    |> Enum.map(fn day ->
      generate_transaction(state.seed, account_id, day)
    end)
  end

  def generate_transaction(seed, account_id, days_ago) do
    :rand.seed(:exs64, seed)

    available = available()
    amounts = amounts(days_ago)
    running_balance = running_balance(available, amounts, days_ago)
    amount = amount(amounts, days_ago)
    transaction_id = transaction_id(days_ago)

    %{
      type: "card_payment",
      running_balance: running_balance,
      amount: amount,
      links: %{
        "self": "http://localhost/accounts/#{account_id}/transactions/#{transaction_id}",
        account: "http://localhost/accounts/#{account_id}"
      },
      id: transaction_id,
      description: Enum.random(@merchants),
      date: date(days_ago),
      account_id: account_id
    }
  end

  defp available do
    100_000..999_999 |> Enum.random() |> Kernel./(100)
  end

  defp amounts(days_ago) do
    1..days_ago |> Enum.map(fn x -> 10_000..99_999 |> Enum.random() |> Kernel./(100) end)
  end

  defp running_balance(available, amounts, days_ago) do
    amounts
    |> Enum.take(days_ago - 1)
    |> Enum.sum()
    |> Kernel.+(available)
    |> to_string()
  end

  defp amount(amounts, days_ago) do
    amounts
    |> Enum.at(days_ago - 1)
    |> Kernel.*(-1)
    |> to_string()
  end

  defp transaction_id(days_ago) do
    days_ago_str =
      days_ago
      |> to_string()
      |> String.pad_leading(2, "0")

    {:exs64, current_seed} = :rand.export_seed()

    "#{days_ago_str}#{current_seed}" |> Base.encode64()
  end

  defp date(days_ago) do
    Date.add(Date.utc_today(), - days_ago)
  end
end

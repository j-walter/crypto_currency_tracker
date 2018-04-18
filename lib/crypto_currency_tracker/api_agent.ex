defmodule CryptoCurrencyTracker.ApiAgent do
  use GenServer
  alias CryptoCurrencyTracker.Api
  alias CryptoCurrencyTracker.ApiAgent
  alias CryptoCurrencyTracker.ApiRefresh

  @cb_headers ApiRefresh.cb_headers
  @digital_currencies ["btc", "ltc", "eth"]
  def digital_currencies, do: @digital_currencies

  def init(v) do
    v = Enum.reduce(@digital_currencies, %{}, fn currency_id, acc ->
      Map.put(acc, currency_id, %{sell: %{current: nil}, buy: %{current: nil}, history: %{}})
    end)
    Process.send_after(self(), {:dates, 365}, 1000)
    {:ok, v}
  end
 
  def handle_info({:dates, days}, state) do
    if days >= 0 do
     Process.send_after(self(), {:dates, days - 5}, 990)
    end
    state = Enum.reduce(state, %{}, fn curr, acc ->
      info = elem(curr, 1)
      |> Map.put(:history, get_year(elem(curr, 0)))
      Map.put(acc, elem(curr, 0), info)
    end)
    {:noreply, state}
  end

  defp get_year(currency_id) do
    today = DateTime.to_date(DateTime.utc_now)
    Enum.reduce(0..5, %{}, fn i, acc ->
      date = Date.add(today, -i)
      Map.put(acc, Date.to_string(date), get_price(currency_id, Date.to_string(date)))
    end)    
  end

  def start_link() do
    state0 = %{}
    GenServer.start_link(__MODULE__, state0, name: __MODULE__)
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def put(key, val) do
    GenServer.call(__MODULE__, {:put, key, val})
  end

  ## Process Implementation

  def handle_call({:get, key}, _from, state) do
    {:reply, Map.get(state, key), state}
  end

  def handle_call({:put, key, val}, _from, state) do
    {:reply, :ok, Map.put(state, key, val)}
  end

  def get_price_on(currency_id, date) do
    price = Map.get(get(currency_id).history, date)
    if !price do
      price = get_price currency_id, date
      put(currency_id, Map.merge(get(currency_id), %{history: Map.put(get(currency_id).history, date, price)}))
      price
    else
      price
    end
  end
  
  defp get_price(currency_id, date) do
    case HTTPoison.get("https://api.coinbase.com/v2/prices/" <> currency_id <> "-USD/spot", @cb_headers, params: %{date: date}) do
    {:ok, %{body: body, status_code: 200}} ->
      String.to_float(Jason.decode!(body)["data"]["amount"])
    _ ->
      nil
    end
  end

end

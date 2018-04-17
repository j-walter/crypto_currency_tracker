defmodule CryptoCurrencyTracker.ApiAgent do
  use GenServer
  alias CryptoCurrencyTracker.Api
  alias CryptoCurrencyTracker.ApiAgent
  alias CryptoCurrencyTracker.ApiRefresh

  def digital_currencies, do: ["btc", "ltc", "eth"]
  @digital_currencies ["btc", "ltc", "eth"]

  def init(v) do
    v = Enum.reduce(@digital_currencies, %{}, fn currency_id, acc ->
      Map.put(acc, currency_id, %{sell: %{current: nil}, buy: %{current: nil}, history: %{}})
    end)
    #handle_info(:dates, self())
    #Process.send_after(self(), :dates, 5000)
    #get_years()
    {:ok, v}
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
      price = GenServer.call ApiRefresh, {:date, currency_id, date}
      put(currency_id, Map.merge(get(currency_id), %{history: Map.put(get(currency_id).history, date, price)}))
      price
    else
      price
    end

  end

  def get_years() do
    Enum.each(@digital_currencies, fn currency_id ->
      get_year(currency_id)
    end)
  end

  def get_year(currency_id) do
    dates = []
    today = DateTime.to_date(DateTime.utc_now)
    Enum.each(0..365, fn acc ->
      date = Date.to_string(Date.add(today, -acc))
      price = GenServer.call ApiRefresh, {:date, currency_id, date}
      put(currency_id, Map.merge(get(currency_id), %{history: Map.put(get(currency_id).history, date, price)}))
    end)
  end

end

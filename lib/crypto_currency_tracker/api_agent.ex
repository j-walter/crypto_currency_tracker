defmodule CryptoCurrencyTracker.ApiAgent do
  use GenServer
  alias CryptoCurrencyTracker.Api
  alias CryptoCurrencyTracker.ApiAgent
  alias CryptoCurrencyTracker.ApiRefresh

  def digital_currencies, do: ["btc", "ltc", "eth"]
  @digital_currencies ["btc", "ltc", "eth"]


  def init(v) do
    v = Enum.reduce(@digital_currencies, %{}, fn currency_id, acc ->
      Map.put(acc, currency_id, %{sell: %{current: nil}, buy: %{current: nil}, history: []})
    end)
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

  def handle_call({:date, key, val}, _from, state) do
    curr = Map.get(state, key)
    val_curr = in_list(curr.history, val)
    if val_curr do
      {:reply, val_curr, state}
    else
      date = GenServer.call ApiRefresh, {:date, key, val}
      up_history = curr.history ++ [date]
      {:reply, date, Map.put(state, key, Map.put(Map.get(state, key), :history, up_history))} 
    end    
  end

  def in_list(list, val) do
    Enum.find(list, fn {date, _} ->
      date == val
    end)
  end

end

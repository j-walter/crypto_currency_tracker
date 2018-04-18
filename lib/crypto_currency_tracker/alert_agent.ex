defmodule CryptoCurrencyTracker.AlertAgent do
  use GenServer
  alias CryptoCurrencyTracker.Alert
  alias CryptoCurrencyTracker.AlertAgent
  alias CryptoCurrencyTracker.ApiAgent
  alias CryptoCurrencyTracker.Repo

  def init(v) do
    v = Enum.reduce(ApiAgent.digital_currencies(), %{}, fn currency_id, acc ->
      Map.put(acc, currency_id, %{})
    end)
    Enum.each(Alert |> Repo.all |> Repo.preload(:user), fn alert ->
      Enum.each(Enum.reject([alert.threshold1, alert.threshold2], &is_nil/1), fn threshold ->
         add_subscriber_helper(v, alert.digital_currency, threshold, alert.user.email, nil)
      end)
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

  def get_thresholds(currency_id) do
    Map.keys(GenServer.call(__MODULE__, {:get, currency_id}))
  end

  def get_subscribers(currency_id, threshold) do
    Map.get(GenServer.call(__MODULE__, {:get, currency_id}), threshold)
  end

  def add_subscriber_helper(to_update, currency_id, threshold, email, current_subscribers) do
    Map.merge(to_update, Map.put(%{}, threshold, MapSet.put(current_subscribers || MapSet.new, email)))
  end

  def add_subscriber(currency_id, threshold, email) do
    GenServer.call(__MODULE__, {:put, currency_id, add_subscriber_helper(get(currency_id), currency_id, threshold, email, get_subscribers(currency_id, threshold))})
  end

  def del_subscriber(currency_id, threshold, email) do
    GenServer.call(__MODULE__, {:put, currency_id, Map.merge(get(currency_id), Map.put(%{}, threshold, MapSet.delete(get_subscribers(currency_id, threshold) || MapSet.new, email)))})
  end

  ## Process Implementation

  def handle_call({:get, key}, _from, state) do
    {:reply, Map.get(state, key), state}
  end

  def handle_call({:put, key, val}, _from, state) do
    {:reply, :ok, Map.put(state, key, val)}
  end

  def handle_call({:keys}, _from, state) do
    {:reply, :ok, Map.keys(state)}
  end

end

defmodule CryptoCurrencyTracker.ApiRefresh do
  use GenServer
  alias CryptoCurrencyTracker.ApiAgent
  alias CryptoCurrencyTracker.AlertAgent

  @cb_headers ["CB-VERSION": "2016-02-18"]
  @cb_options [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 500]

  def init(v) do
    handle_info(:poll, self())
    {:ok, v}
  end

  def start_link() do
    state0 = %{}
    GenServer.start_link(__MODULE__, state0, name: __MODULE__)
  end

  def handle_info(:poll, state) do
    Process.send_after(self(), :poll, 60 * 1000)
    Enum.each([:buy, :sell], fn method ->
      Enum.each(ApiAgent.digital_currencies, fn currency_id ->
        case HTTPoison.get("https://api.coinbase.com/v2/prices/" <> currency_id <> "-USD/" <> Atom.to_string(method), @cb_headers, @cb_options) do
          {:ok, %{body: body, status_code: 200}} ->
            tracker_state = ApiAgent.get(currency_id)
            new_price = Jason.decode!(body)["data"]["amount"]
            old_price = tracker_state[method][:current]
            merged_state = Map.put(%{}, method, Map.merge(tracker_state[method], %{current: String.to_float(new_price)}))
            ApiAgent.put(currency_id, Map.merge(tracker_state, merged_state))
            Enum.each(AlertAgent.get_thresholds(currency_id), fn threshold ->
              if (threshold < new_price and old_price <= threshold) or (threshold >= new_price and old_price > threshold) do
                to_notify = AlertAgent.get_subscribers(currency_id, threshold)
              end
            end)
          _ ->
            nil
        end
      end)
    end)
    {:noreply, state}
  end

  def handle_call({:date, key, val}, _from, state) do
    case HTTPoison.get("https://api.coinbase.com/v2/prices/" <> key <> "-USD/spot", @cb_headers, params: %{date: val}) do
    {:ok, %{body: body, status_code: 200}} ->
      {:reply, {val, Jason.decode!(body)["data"]["amount"]}, state}
    _ ->
      {:noreply, state}
    end 
  end

end

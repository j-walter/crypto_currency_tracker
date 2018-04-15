defmodule CryptoCurrencyTracker.ApiRefresh do
  use GenServer
  alias CryptoCurrencyTracker.ApiAgent

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
    Enum.each([:buy, :sell], fn method ->
      Enum.each(ApiAgent.digital_currencies, fn currency_id ->
        case HTTPoison.get("https://api.coinbase.com/v2/prices/" <> currency_id <> "-USD/" <> Atom.to_string(method), @cb_headers, @cb_options) do
          {:ok, %{body: body, status_code: 200}} ->
            tracker_state = ApiAgent.get(currency_id)
            merged_state = Map.put(%{}, method, Map.merge(tracker_state[method], %{current: String.to_float(Jason.decode!(body)["data"]["amount"])}))
            ApiAgent.put(currency_id, Map.merge(tracker_state, merged_state))
          _ ->
            nil
        end
      end)
    end)
    Process.send_after(self(), :poll, 60 * 1000)
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

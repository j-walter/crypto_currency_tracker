defmodule CryptoCurrencyTracker.ApiRefresh do
  use GenServer
  alias CryptoCurrencyTracker.ApiAgent
  alias CryptoCurrencyTracker.AlertAgent
  alias CryptoCurrencyTracker.Mailer
  alias CryptoCurrencyTracker.Email

  @cb_headers ["CB-VERSION": "2016-02-18"]
  @cb_options [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 500]
  def cb_headers, do: @cb_headers

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
            new_price = String.to_float(Jason.decode!(body)["data"]["amount"])
            old_price = tracker_state[method][:current]
            merged_state = Map.put(tracker_state, method, Map.merge(tracker_state[method], %{current: new_price}))
            ApiAgent.put(currency_id, Map.merge(tracker_state, merged_state))
            Enum.each(AlertAgent.get_thresholds(currency_id), fn threshold ->
              if (threshold < new_price and old_price < threshold) or (threshold > new_price and old_price > threshold) do
                to_notify = AlertAgent.get_subscribers(currency_id, threshold)
                Email.passed_digital_currency_threshold(currency_id, to_notify, threshold, old_price, new_price)
                |> Mailer.deliver_later()
              end
            end)
          _ ->
            nil
        end
      end)
    end)
    CryptoCurrencyTrackerWeb.ApiChannel.update_prices()
    {:noreply, state}
  end

  #def handle_call({:date, currency_id, date}, _from, state) do
  #  case HTTPoison.get("https://api.coinbase.com/v2/prices/" <> currency_id <> "-USD/spot", @cb_headers, params: %{date: date}) do
  #  {:ok, %{body: body, status_code: 200}} ->
  #    {:reply, String.to_float(Jason.decode!(body)["data"]["amount"]), state}
  #  _ ->
  #    {:noreply, state}
  #  end 
  #end

end

defmodule CryptoCurrencyTracker.TrackerAgent do
  use GenServer
  alias CryptoCurrencyTracker.Api
  alias CryptoCurrencyTracker.TrackerAgent
  @cb_headers ["CB-VERSION": "2016-02-18"]
  @cb_options [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 500]
  def digital_currencies, do: ["btc", "ltc", "eth"]

  def init(v) do
    handle_info(:poll, self())
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

  def handle_info(:poll, state) do
    Enum.each(digital_currencies, fn currency_id ->
      case HTTPoison.get("https://api.coinbase.com/v2/prices/" <> currency_id <> "-USD/buy", @cb_headers, @cb_options) do
        {:ok, %{body: body, status_code: 200}} ->
          IO.inspect(Jason.decode!(body)["data"])
        _ ->
          %{}
      end
    end)
    schedule()
    {:noreply, state}
  end

  defp schedule, do: Process.send_after(self(), :poll, 60 * 1000)

end
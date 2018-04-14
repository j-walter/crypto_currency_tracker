defmodule CryptoCurrencyTracker.AlertAgent do
  use GenServer
  alias CryptoCurrencyTracker.Alert
  alias CryptoCurrencyTracker.AlertAgent
  alias CryptoCurrencyTracker.Repo

  def init(v) do
    Enum.each((Alert |> Repo.all |> Repo.preload(:user)), fn alert ->
      Enum.each(Enum.reject([alert.threshold1, alert.threshold2], &is_nil/1), fn threshold ->
        if !get(threshold) do
          put(threshold, MapSet.put(MapSet.new, alert.user.email))
        else
          put(threshold, MapSet.put(get(threshold), alert.user.email))
        end
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

  ## Process Implementation

  def handle_call({:get, key}, _from, state) do
    {:reply, Map.get(state, key), state}
  end

  def handle_call({:put, key, val}, _from, state) do
    {:reply, :ok, Map.put(state, key, val)}
  end

end

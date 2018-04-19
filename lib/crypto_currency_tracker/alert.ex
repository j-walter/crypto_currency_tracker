defmodule CryptoCurrencyTracker.Alert do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias CryptoCurrencyTracker.Repo
  alias CryptoCurrencyTracker.ApiAgent
  alias CryptoCurrencyTracker.AlertAgent
  alias CryptoCurrencyTracker.Alert

  schema "alerts" do
    field :threshold1, :float
    field :threshold2, :float
    field :digital_currency, :string
    belongs_to :user, CryptoCurrencyTracker.User, foreign_key: :user_id, type: :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:threshold1, :threshold2, :digital_currency])
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:alerts_digital_currency_user_id_index)
    |> validate_required([:threshold1, :digital_currency])
    |> validate_inclusion(:digital_currency, ApiAgent.digital_currencies())
  end

  def get(currency_id, user_details) when not is_nil(user_details) do
    user_id = user_details.id || ""
    from(alert in Alert, where: alert.user_id == ^user_id and alert.digital_currency == ^currency_id) |> Repo.one()
  end

  def insert_or_update(currency_id, user_details, thresholds) when not is_nil(currency_id) and not is_nil(user_details) and is_list(thresholds) do
    old_alert = get(currency_id, user_details)
    case Repo.insert(
      Alert.changeset(%Alert{digital_currency: currency_id,
        user_id: user_details.id, threshold1: Enum.at(thresholds, 0), threshold2: Enum.at(thresholds, 1)}),
      on_conflict: [set: [threshold1: Enum.at(thresholds, 0), threshold2: Enum.at(thresholds, 1)]],
      conflict_target: [:digital_currency, :user_id]) do
      {:ok, new_alert} ->
        Enum.each(Enum.reject([old_alert.threshold1, old_alert.threshold2], fn x -> is_nil(x) or x === new_alert.threshold1 or x === new_alert.threshold2 end), fn threshold ->
          AlertAgent.del_subscriber(currency_id, threshold, user_details.email)
        end)
        Enum.each(Enum.reject([new_alert.threshold1, new_alert.threshold2], &is_nil/1), fn threshold ->
          AlertAgent.add_subscriber(currency_id, threshold, user_details.email)
        end)
        new_alert
      _ ->
        nil
    end
  end

  def delete(currency_id, user_details) when not is_nil(currency_id) and not is_nil(user_details) do
    case Repo.get_by(Alert, digital_currency: currency_id, user_id: user_details.id)
      |> Repo.delete do
     {:ok, alert} ->
        Enum.each(Enum.reject([alert.threshold1, alert.threshold2], &is_nil/1), fn threshold ->
          AlertAgent.del_subscriber(currency_id, threshold, user_details.email)
        end)
        alert
     _ ->
      nil
    end
  end

  def client_view(alert) do
    if !!alert do
      %{digital_currency: alert.digital_currency,
        threshold1: alert.threshold1,
        threshold2: alert.threshold2}
    else
      nil
    end
  end

end

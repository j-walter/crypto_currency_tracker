defmodule CryptoCurrencyTracker.Repo.Migrations.UpdateAlertsTable do
  use Ecto.Migration

  def change do
    create unique_index(:alerts, [:digital_currency, :user_id])
  end
end

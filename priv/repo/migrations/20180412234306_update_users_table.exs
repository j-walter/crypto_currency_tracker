defmodule CryptoCurrencyTracker.Repo.Migrations.UpdateUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
	  add :follow_btc, :boolean, null: false, default: true
	  add :follow_ltc, :boolean, null: false, default: true
	  add :follow_eth, :boolean, null: false, default: true
    end
  end
end

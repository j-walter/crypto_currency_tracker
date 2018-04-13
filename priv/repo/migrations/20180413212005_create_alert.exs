defmodule CryptoCurrencyTracker.Repo.Migrations.CreateAlert do
  use Ecto.Migration

  def change do
    create table(:alerts) do
      add :threshold1, :float, null: false
      add :threshold2, :float
      add :digital_currency, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all, type: :string), null: false

      timestamps()
    end

    create index(:alerts, [:user_id])
  end
end

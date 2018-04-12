defmodule CryptoCurrencyTracker.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :string, primary_key: true
      add :email, :string, null: false
      timestamps()
    end

    create index(:users, [:id, :email])
  end
end

defmodule CryptoCurrencyTracker.Repo.Migrations.UpdateUsersTable2 do
  use Ecto.Migration

  def change do
    alter table(:users) do
	  add :first_name, :string
	  add :last_name, :string 
    end
  end
end

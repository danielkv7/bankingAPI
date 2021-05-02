defmodule BankingAPI.Repo.Migrations.CreateAccount do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:user_id, references(:users, type: :uuid))
      add(:amount, :integer)

      timestamps()
    end

    create(index(:accounts, [:user_id]))
  end
end

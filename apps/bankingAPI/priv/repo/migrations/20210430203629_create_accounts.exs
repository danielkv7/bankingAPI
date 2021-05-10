defmodule BankingAPI.Repo.Migrations.CreateAccount do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:user_id, references(:users, type: :uuid), null: false)
      add(:account_number, :serial, null: false)
      add(:amount, :integer, null: false)

      timestamps()
    end

    create(
      constraint(:accounts, "account_number_must_be_between_10000_and_99999",
        check: "account_number >= 10000 and account_number <= 99999"
      )
    )

    create(unique_index(:accounts, [:account_number]))

    execute "ALTER SEQUENCE accounts_account_number_seq START with 10000 RESTART"

    create(constraint(:accounts, "ammount_must_be_0_or_positive", check: "amount >= 0"))

    create(index(:accounts, [:user_id]))
  end
end

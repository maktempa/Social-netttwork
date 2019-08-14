defmodule Backend.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def up do
    create table(:users) do
      # add :email, :string
      add :login, :string
      add :password, :string
      add :name, :string
      add :surname, :string
      add :middle_name, :string
      add :age, :integer
      add :city, :string

      timestamps()
    end
    create unique_index(:users, :login)
  end

  def down do
    drop table(:users)
    drop index(:users, :login)
  end
end

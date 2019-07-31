defmodule Backend.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :password, :string
      add :age, :integer
    end
    create unique_index(:users, :name)
  end
end

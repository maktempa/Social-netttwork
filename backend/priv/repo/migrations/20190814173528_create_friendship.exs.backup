defmodule Backend.Repo.Migrations.CreateFriendshipTable do
  use Ecto.Migration

def up do
  create table(:friendships) do
    add :active, :boolean, default: false, null: false
    add :requester_user_id, references(:users, on_delete: :nothing)
    add :respondent_user_id, references(:users, on_delete: :nothing)


    timestamps()
end
  create index(:friendships, :requester_user_id)
  create index(:friendships, :respondent_user_id)
  create unique_index(:friendships, [:requester_user_id, :respondent_user_id])

  end

  def down do
    drop table(:friendships)
    drop index(:friendships, :requester_user_id)
    drop index(:friendships, :respondent_user_id)
    drop index(:friendships, [:requester_user_id, :respondent_user_id])
  end

end

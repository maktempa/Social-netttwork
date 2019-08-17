# change to many_to_many? any advantages of it?

defmodule Backend.Friendship do
  use Backend.Model

  schema "friendships" do
    field(:active, :boolean, default: false)
    belongs_to(:requester_user, Backend.User, foreign_key: :requester_user_id)
    belongs_to(:respondent_user, Backend.User, foreign_key: :respondent_user_id)

    timestamps()
  end

  # TODO: fix validation, opts
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:active, :requester_user_id, :respondent_user_id])
    |> validate_required([:active])
  end

  def create(requester_user, respondent_user) do
    changeset(%Backend.Friendship{}, %{
      # requester_user_id - fields for cast() in changeset(), requester_user.id = user.id
      requester_user_id: requester_user.id,
      respondent_user_id: respondent_user.id
    })
    |> Backend.Repo.insert()
  end
end

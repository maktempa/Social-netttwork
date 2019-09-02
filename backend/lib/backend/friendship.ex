# change to many_to_many? any advantages of it?

defmodule Backend.Friendship do
  use Backend.Model
  alias Backend.{Repo, User, Friendship}

  schema "friendships" do
    field(:active, :boolean, default: false)
    belongs_to(:requester_user, Backend.User, foreign_key: :requester_user_id)
    belongs_to(:respondent_user, Backend.User, foreign_key: :respondent_user_id)

    timestamps()
  end

  # TODO: fix validation, opts:
  # cant use "def changeset(struct, params \\ %{}) do" bc Backend.Model macro catches changeset/1
  def changeset(struct, params) do
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

  def create2(requester_user, respondent_user) do
    # user = Repo.get_by(User, login: ^requester_user)
    # case user do
    #   :nil -> raise("No sucher requester!")
    #   _ -> do

    #   end
    # end
    with %User{id: ^requester_user} = user <- Repo.get(User, requester_user) do
      user_with_preloaded_friends =
        user
        |> Backend.Repo.preload(:possible_friends)

      user_with_preloaded_friends
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_assoc(
        :possible_friends,
        [Repo.get(Backend.User, respondent_user) | user_with_preloaded_friends.possible_friends]
      )
      |> Repo.update!()
    else
      nil -> {:error, "Requester_user id not found"}
    end

    # with %User{id: ^requester_user} = user <- Repo.get(User, requester_user) do
    #   user
    #   |> Backend.Repo.preload(:possible_friends)
    #   |> Ecto.Changeset.change()
    #   |> Ecto.Changeset.put_assoc(:possible_friends,
    #       [Repo.get(Backend.User, respondent_user) | Repo.preload(user, :possible_friends).possible_friends])
    #   |> Repo.update()
    # else
    #   :nil -> {:error, "Requester_user id not found"}
    # end
  end
end

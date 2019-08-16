# change to many_to_many? any advantages of it?

defmodule Background.Friendship do
  use Backend.Model

  schema "friendships" do
    field :active, :boolean, default: false
    belongs_to :requester_user, Backend.User
    belongs_to :respondent_user, Backend.User
  end

def changeset(struct, params \\%{}) do    # TODO: fix validation, opts
    struct
    |> cast(params, [:active, :requester_user, :respondent_user])
    |> validate_required([:active])
  end
end

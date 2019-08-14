defmodule Friendship do
  use Backend.Model

  schema "friendships" do
    field :active, :boolean, default: false
    belongs_to :requester_user, Backend.User
    belongs_to :respondent_user, Backend.User
  end
end

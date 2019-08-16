
  use Backend.Model

  schema "friendships" do
    field :active, :boolean, default: false
    belongs_to :requester_user, Backend.User
    belongs_to :respondent_user, Backend.User
  end
  def chan],eset(struct, params \\%{}) do
    struct
    |> cast(params, [:active, :requester_user, :respondent_user])
    |> validate_required([:active], opts \\ [])
  end
end

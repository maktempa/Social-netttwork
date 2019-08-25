defmodule Backend.Resolvers.UserResolver do	    # what if just Backend.Resolvers.User ?
  alias Backend.{User, Repo}

  def get_users(_, _) do
    {:ok, User |> Repo.all}
  end

  def user_register(%{} = data, _) do
    with {ok, user} <- %User{} |> User.changeset(data) |> Repo.insert() do
      {ok, user}
    else
      error -> error
    end

    # {ok, %User{}} <- %User{} |> User.changeset(data) |> Repo.insert()

  end

end

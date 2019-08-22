defmodule Backend.Resolvers.UserResolver do	    # what if just Backend.Resolvers.User ?
  alias Backend.{User, Repo}

  def get_users(_, _) do
    {:ok, User |> Repo.all}
  end
end

# what if just BackendWeb.Resolvers.User ?
defmodule BackendWeb.Resolvers.UserResolver do
  alias Backend.{User, Guardian, Repo}

  def get_users(_, _) do
    {:ok, User |> Repo.all()}
  end

  def user_register(%{} = data, _) do
    with {ok, user} <- %User{} |> User.changeset(data) |> Repo.insert() do
      {ok, user}
    else
      error -> error
    end

    # {ok, %User{}} <- %User{} |> User.changeset(data) |> Repo.insert()
  end

  def sign_up(_parents, args, _resolution) do
    args
    # User.create() defined through Backend.Model macro with create()
    |> User.create()
    |> case do
      {:ok, user} ->
        {:ok, user_with_token(user)}

      {:error, changeset} ->
        {:error, extract_error_message(changeset)}
    end
  end

  def authenticate(_parent, args, _resolution) do
    error = {:error, [[field: :login, message: "Invalid login or password"]]}

    case User.find_by(login: String.downcase(args[:login])) do
      nil ->
        error

      user ->
        case Bcrypt.check_pass(user, args[:password]) do
          {:error, _} ->
            error

          {:ok, user} ->
            {:ok, user_with_token(user)}
        end
    end
  end

  defp user_with_token(user) do
    {:ok, token, _claims} = Guardian.encode_and_sign(user)
    IO.puts("Token is: #{inspect(token)}")
    Map.put(user, :token, token)
  end

  # defp user_with_token(user) do
  # case Guardian.encode_and_sign(user) do
  # {:ok, token, _claims} -> Map.put(user, :token, token)
  #   # {:error, msg} -> {:error, msg}
  #   _ -> {:error}
  # end
  # end

  defp extract_error_message(changeset) do
    changeset.errors
    |> Enum.map(fn {field, {error, _details}} ->
      [
        field: field,
        message: String.capitalize(error)
      ]
    end)
  end
end

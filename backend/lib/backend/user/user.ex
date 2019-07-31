# To do: 1) save hash, not password; 2) make email unique constraint? (then validate it by using regex; need make unique in migration to - it is db-side check); 3) more informative registration feedback; 
#	 4) put  checks in external files(controllers?); 5) __MODULE__ for Backend.User; 6) how to connect to outer world?; 7) etc
defmodule Backend.User do
  use Ecto.Schema

  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string
    field :age, :integer
    # plus auto field :id, integer
  end

def changeset(user, params \\ %{}) do
  user
  |> Ecto.Changeset.cast(params, [:email, :name, :password, :age])
  |> Ecto.Changeset.validate_required([:name, :password])
  |> Ecto.Changeset.unique_constraint(:name)
end

# creating user
def create(params) do
  #changeset(%Backend.User{}, params)
  #|> Backend.Repo.insert()

  changeset_for_registration = Backend.User.changeset(%Backend.User{}, params)
  case Backend.Repo.insert(changeset_for_registration) do
    {:ok, user} ->
      IO.puts("User registered")
    {:error, changeset} ->
      IO.puts("User registration failed!")
  end
end

# user authentification
def authenticate(name, password) do
  user = Backend.Repo.get_by(Backend.User, name: name)
#  case user do
#    nil -> 
#     IO.puts("No such user")
#    _ ->

  cond do
    user == nil ->
      IO.puts("No such user")
    user.password != password ->
      IO.puts("Wrong password")
    user.password == password ->
      IO.puts("Authentification succesful")
    true ->
      IO.puts("Encountered some error(s)")
  end
end

end




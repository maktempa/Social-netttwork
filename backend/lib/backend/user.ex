# To do: 1) save hash, not password; 2) make email unique constraint? (then validate it by using regex; need make unique in migration too - it is db-side check); 3) more informative registration feedback;
# 	 4) put  checks in external files(controllers?); 5) __MODULE__ for Backend.User; 6) how to connect to outer world?; 7) validate_confirmation(); 8) etc

defmodule Backend.User do
  # use Ecto.Schema
  use Backend.Model

  # import Ecto.Changeset       # alows to use cast() and other functions instead of Ecto.Changeset.cast()

  schema "users" do
    # field :email, :string
    field(:login, :string, unique: true)
    # make it virtual after hash relise: field :password, :string, :virtual
    # field(:password, :string)
    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)
    field(:password_hash, :string)
    field(:token, :string, virtual: true)
    field(:name, :string)
    field(:surname, :string)
    field(:middle_name, :string)
    field(:age, :integer)
    field(:city, :string)
    # plus auto field :id, integer

    # Adds :inserted_at and :updated_at timestamp columns.
    timestamps()

    # has_many :outcome_friendships, Background.Friendship, foreign_key: :requester_user_id
    # has_many :income_friendships, Background.Friendship, foreign_key: :respondent_user_id
    many_to_many(:possible_friends, Backend.User,
      join_through: Backend.Friendship,
      join_keys: [requester_user_id: :id, respondent_user_id: :id]
      # join_keys: [respondent_user_id: :id, requester_user_id: :id]
    )

    many_to_many(:wannabe_friends, Backend.User,
      join_through: Backend.Friendship,
      join_keys: [respondent_user_id: :id, requester_user_id: :id]
      # join_keys: [respondent_user_id: :id, requester_user_id: :id]
    )
  end

  @spec changeset(
          {map, map} | %{:__struct__ => atom | %{__changeset__: map}, optional(atom) => any},
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def changeset(user_struct, params \\ %{}) do
    user_struct
    # |> Ecto.Changeset.cast(params, [:email, :login, :password, :age])
    |> Ecto.Changeset.cast(params, [
      :login,
      :password,
      :password_confirmation,
      :name,
      :surname,
      :middle_name,
      :age,
      :city
    ])
    |> Ecto.Changeset.validate_required([:login, :password, :password_confirmation],
      message: "Both login and password should be provided"
    )
    |> Ecto.Changeset.validate_length(:password,
      min: 3,
      max: 100,
      message: "Password must have more then 2 symbols"
    )
    # has a number
    |> Ecto.Changeset.validate_format(:password, ~r/[0-9]+/,
      message: "Password must contain a number"
    )
    # has an upper case letter
    |> Ecto.Changeset.validate_format(:password, ~r/[A-Z]+/,
      message: "Password must contain an upper-case letter"
    )
    # has a lower case letter
    |> Ecto.Changeset.validate_format(:password, ~r/[a-z]+/,
      message: "Password must contain a lower-case letter"
    )
    |> Ecto.Changeset.validate_confirmation(:password,
      message: "Password and password confirmation don't match",
      required: true
    )
    |> Ecto.Changeset.validate_inclusion(:age, 1..100,
      message: "Age should be varied from 1 to 100"
    )
    |> Ecto.Changeset.unique_constraint(:login, message: "Login already exists")
    |> put_password_hash
  end

  # creating user
  def create(params) do
    # changeset(%Backend.User{}, params)
    # |> Backend.Repo.insert()

    changeset_for_registration = Backend.User.changeset(%Backend.User{}, params)

    case Backend.Repo.insert(changeset_for_registration) do
      {:ok, user} ->
        IO.puts("User registered succesfully!")

      {:error, changeset} ->
        IO.puts("User registration failed! \n #{inspect(changeset.errors)}")
    end
  end

  # user authentication
  def authenticate(login, password) do
    user = Backend.Repo.get_by(Backend.User, login: login)
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

  # put_password_hash() for changeset with password changes
  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, Bcrypt.add_hash(password))
    IO.puts(inspect("Changeset is equal: #{changeset}"))
  end

  # put_password_hash() in case no password changes
  defp put_password_hash(changeset), do: changeset
end

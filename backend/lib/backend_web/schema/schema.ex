defmodule Backend.Schema do
  use Absinthe.Schema

  alias Backend.Resolvers.UserResolver

    query do
      field :get_users, list_of(:users) do
        resolve &UserResolver.get_users/2
      end

      field :test, :string do
        arg :name, non_null(:string)

        resolve fn %{name: name}, _ ->
          {:ok, "#{name} reply"}
        end
      end
    end

    object :users do
      field :id, non_null(:id)
      field :login, non_null(:string)
      field :name, :string      # TODO: check if non_null will conflict with db schema in some cases?
      field :surname, :string   # "message": "Cannot return null for non-nullable field",
      field :age, :integer
    end
  end

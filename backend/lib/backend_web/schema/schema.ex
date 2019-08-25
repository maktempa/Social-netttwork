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

    mutation do
      # mutation name "register_user", response type ":users" (schema/type described at Backend.User:user), or response could be object defined here
      field :user_register, :users do
        arg :login, non_null(:string)
        arg :password, non_null(:string)  #TODO: fix plain password?
        arg :name, :string
        arg :surname, :string
        arg :middle_name, :string
        arg :age, :integer
        arg :city, :string
        resolve &UserResolver.user_register/2
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

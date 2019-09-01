# TODO: Export types and fields to separate files - https://hexdocs.pm/absinthe/importing-fields.html
defmodule BackendWeb.Schema.Schema do
  use Absinthe.Schema

  alias BackendWeb.Resolvers.UserResolver

  query do
    field :get_users, list_of(:user) do
      resolve(&UserResolver.get_users/2)
    end

    field :test, :string do
      arg(:name, non_null(:string))

      resolve(fn %{name: name}, _ ->
        {:ok, "#{name} reply"}
      end)
    end
  end

  mutation do
    # mutation name "register_user", response type ":users" (schema/type described at Backend.User:user), or response could be object defined here
    field :user_register, :user do
      arg(:login, non_null(:string))

      # TODO: fix plain password? How to forbid to reply this field on query - in object definition (query definition or in resolver?)
      arg(:password, non_null(:string))
      arg(:name, :string)
      arg(:surname, :string)
      arg(:middle_name, :string)
      arg(:age, :integer)
      arg(:city, :string)
      resolve(&UserResolver.user_register/2)
    end
  end

  # subscription for creation of users with specified age
  # TODO: add multitrigger like on age < 18 ? is it possible?
  subscription do
    field :user_registered_by_age, :user do
      arg(:age, non_null(:integer))

      config(fn args, _ ->
        {:ok, topic: args.age}
      end)

      # trigger on :user_register mutation
      trigger(:user_register,
        topic: fn user ->
          user.age
        end
      )
    end
  end

  object :user do
    field(:id, non_null(:id))
    field(:login, non_null(:string))
    # TODO: check if non_null will conflict with db schema in some cases?
    field(:name, :string)
    # "message": "Cannot return null for non-nullable field",
    field(:surname, :string)
    field(:age, :integer)
  end
end

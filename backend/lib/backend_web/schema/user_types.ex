# TODO: Export types and fields to separate files - https://hexdocs.pm/absinthe/importing-fields.html
defmodule BackendWeb.Schema.UserTypes do
  # use Absinthe.Schema
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1, dataloader: 3]

  alias BackendWeb.{Resolvers, Data}

  @desc "Represents site user"
  object :user do
    field(:id, non_null(:id))
    field(:login, non_null(:string))
    # TODO: check if non_null will conflict with db schema in some cases?
    field(:name, :string)
    # "message": "Cannot return null for non-nullable field",
    field(:surname, :string)
    field(:age, :integer)
    field(:gender, :integer)

    # TODO: extract many to many association - friends
    # field(:friends, list_of(:user),
    #   resolve: dataloader(Data, some_binded_table, args(%{where: ":active == true"}))
    # )
  end

  object :user_queries do
    @desc "Gets all users"
    field :get_users, list_of(:user) do
      resolve(&Resolvers.UserResolver.get_users/2)
    end

    # TODO: add user search, current user, etc
    @desc "Search users"
    field :search_users, list_of(:user) do
      arg(:search_term, non_null(:string))

      resolve(&Resolvers.UserResolver.search_users/3)
    end

    @desc "Get current user"
    field :current_user, :user do
      resolve(&Resolvers.UserResolver.current_user/3)
    end

    field :test, :string do
      arg(:name, non_null(:string))

      resolve(fn %{name: name}, _ ->
        {:ok, "#{name} reply"}
      end)
    end
  end

  # TODO: check if signed in?
  object :user_mutations do
    @desc "Register user"
    # mutation name "register_user", response type ":user"  object defined here
    field :user_register, :user do
      arg(:login, non_null(:string))

      # TODO: fix plain password? How to forbid to reply this field on query - in object definition (query definition or in resolver?)
      arg(:password, non_null(:string))
      arg(:password_confirmation, non_null(:string))
      arg(:name, :string)
      arg(:surname, :string)
      arg(:middle_name, :string)
      arg(:age, :integer)
      arg(:city, :string)

      resolve(&Resolvers.UserResolver.user_register/2)
    end

    @desc "Authenticate"
    field :authenticate, :user do
      arg(:login, non_null(:string))
      arg(:password, non_null(:string))
      arg(:password_confirmation, non_null(:string))

      resolve(&Resolvers.UserResolver.authenticate/3)
    end

    @desc "Sign up"
    # mutation name "sign_up", response type ":user"  object defined here; has less parameteres (only not_null ones)
    field :sign_up, :user do
      arg(:login, non_null(:string))

      # TODO: fix plain password? How to forbid to reply this field on query - in object definition (query definition or in resolver?)
      arg(:password, non_null(:string))
      arg(:password_confirmation, non_null(:string))
      # arg(:name, :string)
      # arg(:surname, :string)
      # arg(:middle_name, :string)
      # arg(:age, :integer)
      # arg(:city, :string)

      resolve(&Resolvers.UserResolver.sign_up/3)
    end
  end

  # subscription for creation of users with age specified
  # TODO: add multitrigger like on age < 18 ? is it possible?
  object :user_subscriptions do
    @desc "Subscription on user creation with ceratain age"
    field :user_registered_by_age, :user do
      arg(:age, non_null(:integer))

      config(fn args, _ ->
        {:ok, topic: args.age}
      end)

      # trigger on :user_register mutation
      # TODO: change /add tringger for "sign up" event
      trigger(:user_register,
        topic: fn user ->
          user.age
        end
      )
    end
  end
end

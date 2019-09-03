defmodule BackendWeb.Schema do
  use Absinthe.Schema

  alias BackendWeb.Data
  # import all type files in BackendWeb.Schema.Types module
  import_types(BackendWeb.Schema.UserTypes)

  query do
    import_fields(:user_queries)
  end

  mutation do
    # user sign-in/sign-up only through http GraphQL mutations, no need for WebSocket?
    import_fields(:user_mutations)
  end

  subscription do
    import_fields(:user_subscriptions)
  end

  # allows to batch resolving associated fields (no N+1 problem); use examples:
  # object :comment do
  # field :id, :id
  # field :body, :string
  # field :inserted_at, :naive_datetime

  # field :post, :post, resolve: dataloader(Data)
  # field :user, :user, resolve: dataloader(Data)
  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Data, Data.data())

    Map.put(ctx, :loader, loader)
  end

  # TODO: check if really need this. if not - comment then/
  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  # def middleware(middleware, _field, _object) do
  #   [NewRelic.Absinthe.Middleware] ++ middleware
  # end
end

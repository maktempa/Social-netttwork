defmodule BackendWeb.SchemaSignInUp do
  use Absinthe.Schema
  # import all type files in BackendWeb.Schema.Types module
  import_types(BackendWeb.Schema.UserTypes)

  query do
    #   import_fields(:user_queries)
  end

  mutation do
    import_fields(:user_mutations)
  end

  # subscription do
  #   # import_fields :user_subscriptions
  # end
end

defmodule BackendWeb.Router do
  use BackendWeb, :router

  # pipeline :api do
  #   plug(:accepts, ["json"])
  # end

  # scope "/api", BackendWeb do
  #   pipe_through(:api)
  # end

  scope "/" do
    forward(
      "/graphql",
      Absinthe.Plug,
      # TODO: !!! Check if WebSocket requires scheme to be specified here. If true, then use BackendWeb.Schema !!!
      # TODO: !!! Check if GraphQL could be used through this path withouh WS authentication. If true, then add authentication plug
      schema: BackendWeb.SchemaSignInUp
      # schema: BackendWeb.Schema
      # socket_url: "ws://localhost:4000/socket"
    )

    # forward(

    # )

    # enable GraphiQl for dev enironment
    if Mix.env() == :dev do
      forward("/graphiql", Absinthe.Plug.GraphiQL,
        # schema: BackendWeb.Schema,
        schema: BackendWeb.SchemaSignInUp,
        # only for subscription queries???
        socket_url: "ws://localhost:4000/socket"
      )
    end
  end
end

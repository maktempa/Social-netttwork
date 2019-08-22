defmodule BackendWeb.Router do
  use BackendWeb, :router

  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  # scope "/api", BackendWeb do
  #   pipe_through :api

  scope "/" do
	  forward "/graphiql",
			Absinthe.Plug.GraphiQL,
			schema: Backend.Schema
  end

end

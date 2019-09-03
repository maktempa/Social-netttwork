defmodule BackendWeb.UserSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: BackendWeb.Schema

  alias Absinthe.Phoenix.Socket
  alias Backend.{Guardian, User}
  ## Channels
  # channel "room:*", BackendWeb.RoomChannel

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.

  # def connect(_params, socket, _connect_info) do
  # {:ok, socket}
  # end

  # TODO: check if needed
  # transport :websocket, Phoenix.Transports.WebSocket

  def connect(%{"token" => token}, socket, _connect_info) do
    with {:ok, claim} <- Guardian.decode_and_verify(token),
         user when not is_nil(user) <- User.find(claim["sub"]) do
      socket = Socket.put_options(socket, context: %{current_user: user})
      IO.puts("Token in soket is: #{inspect(token)}")
      {:ok, socket}
    else
      # _ -> {:ok, socket}
      _ ->
        IO.puts("Error - no token in soket! ")
        :error
    end
  end

  # TODO: only for testing subscrtion until get frontend which works with GraphQL queries and mutations through WebSockets. Comment then
  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     BackendWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(%{assigns: %{absinthe: %{opts: [context: %{current_user: user}]}}}) do
    "user_socket:#{user.od}"
  end

  def id(_socket), do: nil
end

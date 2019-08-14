defmodule Backend.Model do
  alias Backend.Repo

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      import Ecto.Query


    end
  end

end

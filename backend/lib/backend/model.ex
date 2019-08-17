defmodule Backend.Model do
  alias Backend.Repo

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      # TODO: check if doesn't geti imported, need to unquote()?
      # Answer: 1. Neet do use 'use'?; 2. Need to be used only inside of module (not in shell or script)
      import Ecto.Query
    end
  end
end

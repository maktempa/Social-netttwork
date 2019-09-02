# TODO: remove(macros are bad and program obscure) or keep (help to extract boilerplate functions)?
defmodule Backend.Model do
  alias Backend.Repo

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      # TODO: check if doesn't get imported, need to unquote()?
      # Answer: 1. Need do use 'use'?; 2. Need to be used only inside of module (not in shell or script)
      import Ecto.Query

      def find(id) do
        Repo.get(__MODULE__, id)
      end

      def find_by(conds) do
        Repo.get_by(__MODULE__, conds)
      end

      def create(attrs) do
        attrs
        |> changeset()
        |> Repo.insert()
      end

      def changeset(attrs) do
        # TODO: check if same as %__MODULE__{} (e.g. %User{})
        __MODULE__.__struct__()
        |> changeset(attrs)
      end
    end
  end
end

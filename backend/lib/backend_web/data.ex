defmodule BackendWeb.Data do
  import Ecto.Query

  def data() do
    Dataloader.Ecto.new(Backend.Repo, query: &query/2)
  end

  # def query(queryable, params) do
  #   case Map.get(params, :order_by) do
  #     nil ->
  #       queryable

  #     order_by ->
  #       from(record in queryable, order_by: ^order_by)
  #   end
  # end

  def query(queryable, params) do
    res =
      case Map.get(params, :order_by) do
        nil ->
          queryable

        order_by ->
          from(record in queryable, order_by: ^order_by)
      end

    case Map.get(params, :where) do
      nil ->
        res

      where ->
        # from(c in City, where: [country: "Sweden"]) or from(c in City, where: c.country == "Sweden")
        # City |> where(country: "Sweden") or City |> where([c], c.country == "Sweden")
        from(record in res, where: ^where)
    end
  end
end

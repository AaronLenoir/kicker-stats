defmodule WebApiWeb.StatsController do
  use WebApiWeb, :controller

  def index(conn, params) do
    render(conn, :index, year: Map.get(params, "year"))
  end
end

defmodule Nebula.DashboardController do
  use Nebula.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

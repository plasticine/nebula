defmodule Orchestrator.DashboardController do
  use Orchestrator.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

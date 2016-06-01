defmodule Nebula.DeployController do
  use Nebula.Web, :controller
  alias Nebula.Deploy

  def show(conn, %{"id" => id}) do
    deploy = Repo.get!(Deploy, id) |> Repo.preload([:project, :job])
    render(conn, "show.html", deploy: deploy)
  end
end

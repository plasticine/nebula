defmodule Nebula.Db.DeployController do
  use Nebula.Web, :controller
  alias Nebula.Db.Deploy
  alias Ecto.Changeset

  def show(conn, %{"id" => id}) do
    deploy = Repo.get!(Deploy, id) |> Repo.preload([:project, :job])
    render(conn, "show.html", deploy: deploy)
  end

  def delete(conn, %{"id" => id}) do
    deploy = Repo.get!(Deploy, id)
    Nomad.API.Job.delete(deploy.slug)
    Nebula.Scheduler.Job.stop(id)
    Repo.update(Changeset.change(deploy, %{state: Deploy.states.complete}))
    send_resp(conn, :no_content, "")
  end
end

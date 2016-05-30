defmodule Orchestrator.Api.V1.DeploymentController do
  use Orchestrator.Web, :controller
  alias Orchestrator.Deploy
  alias Orchestrator.Project
  alias Sluginator
  alias DeployManager

  def index(conn, _params) do
    deployments = Deploy |> Repo.all
    render(conn, "index.json", deployments: deployments)
  end

  def show(conn, %{"id" => id}) do
    deployment = Repo.get(Deploy, id)
    render conn, "show.json", deployment: deployment
  end

  def create(conn, params) do
    deployment = Repo.insert!(Deploy.changeset(%Deploy{}, filter_deploy_params(params)))
    DeployManager.create(deployment)
    render conn, "show.json", deployment: deployment
  end

  defp filter_deploy_params(params) do
    project = Repo.get!(Project, Map.get(params, "project_id"))

    %{
      project_id: project.id,
      ref: Map.get(params, "ref"),
      rev: Map.get(params, "rev"),
      slug: Sluginator.build,
      state: "accepted"
    }
  end
end

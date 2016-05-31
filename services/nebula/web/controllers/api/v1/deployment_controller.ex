defmodule Nebula.Api.V1.DeploymentController do
  use Nebula.Web, :controller
  alias Nebula.Deploy
  alias Sluginator
  alias DeployManager

  plug :scrub_params, "deployment" when action in [:create, :update]

  def index(conn, _params) do
    deployments = Deploy |> Repo.all
    render(conn, "index.json", deployments: deployments)
  end

  def create(conn, params) do
    changeset = Deploy.changeset(%Deploy{}, filter_deploy_params(params))

    case Repo.insert(changeset) do
      {:ok, deployment} ->
        DeployManager.create(deployment)
        conn
        |> put_status(:created)
        |> put_resp_header("location", api_v1_deployment_path(conn, :show, deployment))
        |> render("show.json", deployment: deployment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Nebula.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    deployment = Repo.get(Deploy, id)
    render conn, "show.json", deployment: deployment
  end

  def update(conn, %{"id" => id, "deployment" => deployment_params}) do
    deployment = Repo.get!(Deploy, id)
    changeset = Deploy.changeset(deployment, deployment_params)

    case Repo.update(changeset) do
      {:ok, deployment} ->
        render(conn, "show.json", deployment: deployment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Nebula.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    deployment = Repo.get!(Deploy, id)
    Repo.delete!(deployment)
    send_resp(conn, :no_content, "")
  end

  defp filter_deploy_params(%{"deployment" => deployment_params}) do
    project = Repo.get!(Nebula.Project, Map.get(deployment_params, "project_id"))

    %{
      project_id: project.id,
      ref: Map.get(deployment_params, "ref"),
      rev: Map.get(deployment_params, "rev"),
      slug: Sluginator.build,
      state: "accepted"
    }
  end
end

defmodule Nebula.Api.V1.DeployController do
  use Nebula.Web, :controller
  alias Nebula.Deploy
  alias Nebula.Job
  alias Sluginator
  use Timex

  plug :scrub_params, "deploy" when action in [:create, :update]

  def index(conn, _params) do
    deploys = Deploy |> Repo.all
    render(conn, "index.json", deploys: deploys)
  end

  def create(conn, params) do
    deploy_changeset = Deploy.changeset(%Deploy{}, filter_deploy_params(params))

    case Repo.insert(deploy_changeset) do
      {:ok, deploy} ->
        Job.changeset(Ecto.build_assoc(deploy, :job), filter_job_params(params))
        |> Repo.insert!
        |> Nebula.Scheduler.Job.create

        conn
        |> put_status(:created)
        |> put_resp_header("location", api_v1_deploy_path(conn, :show, deploy))
        |> render("show.json", deploy: deploy)
      {:error, deploy_changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Nebula.ChangesetView, "error.json", changeset: deploy_changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    deploy = Repo.get(Deploy, id)
    render conn, "show.json", deploy: deploy
  end

  def update(conn, %{"id" => id, "deploy" => deploy_params}) do
    deploy = Repo.get!(Deploy, id)
    changeset = Deploy.changeset(deploy, deploy_params)

    case Repo.update(changeset) do
      {:ok, deploy} ->
        render(conn, "show.json", deploy: deploy)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Nebula.ChangesetView, "error.json", changeset: changeset)
    end
  end

  defp filter_deploy_params(%{"deploy" => deploy_params}) do
    project = Repo.get!(Nebula.Project, Map.get(deploy_params, "project_id"))

    %{
      expire_at: default_expire_at,
      project_id: project.id,
      ref: Map.get(deploy_params, "ref"),
      rev: Map.get(deploy_params, "rev"),
      slug: Sluginator.build,
      state: Deploy.states.accepted,
    }
  end

  defp filter_job_params(%{"deploy" => deploy_params}) do
    %{
      spec: Map.get(deploy_params, "job")
    }
  end

  # TODO: will want to make this come from config at some point...
  defp default_expire_at, do: Timex.shift(DateTime.now, hours: 2)
end

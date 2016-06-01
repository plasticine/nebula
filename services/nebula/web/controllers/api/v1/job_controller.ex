defmodule Nebula.Api.V1.JobController do
  use Nebula.Web, :controller
  alias Nebula.Job
  alias Nebula.Deploy

  plug :scrub_params, "job" when action in [:create]
  plug :scrub_params, "deploy_id" when action in [:create]

  def create(conn, %{"deploy_id" => deploy_id, "job" => job_params}) do
    changeset =
      Ecto.build_assoc(Repo.get!(Deploy, deploy_id), :job)
      |> Job.changeset(job_params)

    case Repo.insert(changeset) do
      {:ok, job} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", api_v1_deploy_job_path(conn, :show, job))
        |> render("show.json", job: job)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Nebula.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    job = Repo.get!(Job, id)
    render(conn, "show.json", job: job)
  end
end

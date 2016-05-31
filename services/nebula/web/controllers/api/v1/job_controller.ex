defmodule Nebula.Api.V1.JobController do
  use Nebula.Web, :controller
  alias Nebula.Job

  plug :scrub_params, "job" when action in [:create, :update]

  def create(conn, %{"job" => job_params}) do
    IO.inspect job_params

    changeset = Job.changeset(%Job{}, job_params)

    case Repo.insert(changeset) do
      {:ok, job} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", api_v1_deployment_job_path(conn, :show, job))
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

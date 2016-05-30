defmodule Nebula.LogController do
  use Nebula.Web, :controller

  alias Nebula.Log

  plug :scrub_params, "log" when action in [:create, :update]

  def index(conn, _params) do
    logs = Repo.all(Log)
    render(conn, "index.html", logs: logs)
  end

  def new(conn, _params) do
    changeset = Log.changeset(%Log{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"log" => log_params}) do
    changeset = Log.changeset(%Log{}, log_params)

    case Repo.insert(changeset) do
      {:ok, _log} ->
        conn
        |> put_flash(:info, "Log created successfully.")
        |> redirect(to: log_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    log = Repo.get!(Log, id)
    render(conn, "show.html", log: log)
  end

  def edit(conn, %{"id" => id}) do
    log = Repo.get!(Log, id)
    changeset = Log.changeset(log)
    render(conn, "edit.html", log: log, changeset: changeset)
  end

  def update(conn, %{"id" => id, "log" => log_params}) do
    log = Repo.get!(Log, id)
    changeset = Log.changeset(log, log_params)

    case Repo.update(changeset) do
      {:ok, log} ->
        conn
        |> put_flash(:info, "Log updated successfully.")
        |> redirect(to: log_path(conn, :show, log))
      {:error, changeset} ->
        render(conn, "edit.html", log: log, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    log = Repo.get!(Log, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(log)

    conn
    |> put_flash(:info, "Log deleted successfully.")
    |> redirect(to: log_path(conn, :index))
  end
end

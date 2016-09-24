defmodule Nebula.Scheduler.Loader do
  use GenServer
  require Logger
  import Ecto.Query
  alias Nebula.Scheduler.Job

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    Process.send_after(self(), :started, 0)
    {:ok, []}
  end

  def handle_info(:started, []) do
    start_missing_jobs
    {:noreply, []}
  end

  @doc """
  Potentially if the Nebula app reboots or shuts down or whatever, there can be
  a case where Nomad Jobs are still in-flight. In this case we should re-start
  the Nebula jobs to track the status of them.
  This method will start job processes for jobs that are not 'complete'.
  """
  def start_missing_jobs do
    Logger.info "[scheduler] Checking for missing Job processes after start..."
    Nebula.Job
    |> join(:left, [job], deploy in assoc(job, :deploy))
    |> where([_, deploy], deploy.state != ^Nebula.Deploy.states.complete)
    |> select([job, _], job.id)
    |> Nebula.Repo.all
    |> Enum.filter(fn(id) -> Job.get(id) == :undefined end)
    |> Enum.map(&Job.create/1)
  end
end

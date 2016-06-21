defmodule Nebula.Scheduler do
  use Supervisor
  require Logger

  def start_link do
    Logger.info "[scheduler] Started scheduler process"
    Supervisor.start_link(__MODULE__, [], name: :scheduler)
  end

  def init(_) do
    # register_missing_jobs
    supervise([worker(Nebula.Scheduler.Job, [])], strategy: :simple_one_for_one)
  end

  def register_job(id) do
    Supervisor.start_child(:scheduler, [id])
  end

  def jobs do
    # TODO this does not work
    Supervisor.count_children(:scheduler)
  end

  # defp register_missing_jobs do
  #   Logger.info "[scheduler] Checking for missing job processes..."
  #   Nebula.Repo.all(Nebula.Job)
  #   |> Enum.map(fn job -> register_job(job.id) end)
  #   |> IO.inspect
  # end
end

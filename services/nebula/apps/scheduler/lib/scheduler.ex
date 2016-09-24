defmodule Nebula.Scheduler do
  use Supervisor
  require Logger

  def start_link do
    Logger.info "[scheduler] Started scheduler process"
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [
      worker(Nebula.Scheduler.JobPool, []),
      worker(Nebula.Scheduler.Loader, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end

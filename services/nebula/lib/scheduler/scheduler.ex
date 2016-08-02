defmodule Nebula.Scheduler do
  use Supervisor
  require Logger
  alias Nebula.Scheduler.JobPool
  alias Nebula.Scheduler.Loader

  def start_link do
    Logger.info "[scheduler] Started scheduler process"
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [
      worker(JobPool, []),
      worker(Loader, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end

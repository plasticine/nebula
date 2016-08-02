defmodule Nebula.Scheduler.JobPool do
  use Supervisor
  alias Nebula.Scheduler.Job

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    supervise([worker(Job, [])], strategy: :simple_one_for_one)
  end

  def start_job(id) do
    Supervisor.start_child(__MODULE__, [id])
  end

  def jobs do
    # TODO this does not work
    Supervisor.count_children(__MODULE__)
  end
end

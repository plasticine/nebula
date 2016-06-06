defmodule Scheduler do
  use Supervisor
  require Logger

  def start_link do
    Logger.info "[Scheduler] Running Scheduler"
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    config = [
      {:name, {:local, :queue}}, {:worker_module, Scheduler.Queue}, {:size, 1}, {:max_overflow, 5},
    ]
    children = [
      :poolboy.child_spec(:queue, config, [])
    ]
    supervise(children, strategy: :one_for_one)
  end

  def register(job) do
    spawn fn ->
      :poolboy.transaction(:queue, fn(pid) ->
        GenServer.call(pid, {:register, job})
      end, :infinity)
    end
  end
end

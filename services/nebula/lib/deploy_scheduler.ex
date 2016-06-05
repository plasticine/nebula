defmodule DeployScheduler do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    poolboy_config = [
      {:name, {:local, :deploy_scheduler}},
      {:worker_module, DeployScheduler.Worker},
      {:size, 2},
      {:max_overflow, 10},
    ]
    children = [:poolboy.child_spec(:deploy_scheduler, poolboy_config, [])]
    supervise(children, strategy: :one_for_one)
  end

  def register(job) do
    spawn fn -> transaction({:register, job}) end
  end

  defp transaction(args) do
    :poolboy.transaction(:deploy_scheduler, fn(pid) -> GenServer.call(pid, args) end, :infinity)
  end
end

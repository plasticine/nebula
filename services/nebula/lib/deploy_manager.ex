defmodule DeployManager do
  use Supervisor

  def start_link, do: Supervisor.start_link(__MODULE__, [])

  def init([]) do
    poolboy_config = [
      {:name, {:local, :deploy_queue}},
      {:worker_module, DeployManager.Worker},
      {:size, 1},
      {:max_overflow, 10},
    ]
    children = [:poolboy.child_spec(:deploy_queue, poolboy_config, [])]
    supervise(children, strategy: :one_for_one)
  end

  def create(deployment) do
    spawn fn -> transaction({:create, deployment}) end
  end

  defp transaction(args) do
    :poolboy.transaction(:deploy_queue, fn(pid) -> GenServer.call(pid, args) end, :infinity)
  end
end

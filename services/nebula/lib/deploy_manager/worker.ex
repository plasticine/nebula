defmodule DeployManager.Worker do
  use GenServer
  require Logger
  alias Nebula.Deploy
  alias Nebula.Repo
  alias DeployManager.Haproxy

  def start_link([]), do: GenServer.start_link(__MODULE__, [], [])
  def init(state), do: {:ok, state}

  def handle_call({:create, deployment}, _, state) do
    Logger.info "handle_call create"

    deployment = Repo.update!(Deploy.changeset(deployment, %{state: "creating"}))
    {:ok, config} = Haproxy.regenerate!

    {:reply, {:ok, deployment}, state}
    # {:reply, {:error, reason}, state}
  end
end

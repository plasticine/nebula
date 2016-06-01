defmodule DeployManager.Worker do
  use GenServer
  require Logger
  alias Nebula.Deploy
  alias Nebula.Repo
  alias DeployManager.Haproxy

  def start_link([]), do: GenServer.start_link(__MODULE__, [], [])
  def init(state), do: {:ok, state}

  def handle_call({:create, deploy}, _, state) do
    Logger.info "handle_call create"

    deploy = Repo.update!(Deploy.changeset(deploy, %{state: "creating"}))
    {:ok, config} = Haproxy.regenerate!

    {:reply, {:ok, deploy}, state}
    # {:reply, {:error, reason}, state}
  end
end

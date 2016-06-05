defmodule DeployScheduler.Worker do
  use GenServer
  require Logger
  # alias Nebula.Deploy
  # alias Nebula.Repo
  # alias DeployScheduler.Haproxy

  ## GenServer initialization
  def start_link([]) do
    GenServer.start_link(__MODULE__, [])
  end

  def init() do
    {:ok, %{jobs: []}}
  end

  def handle_call({:register, job}, _, state) do
    Logger.info "[DeployScheduler] Registering new Job for Scheduling"
    next_state = Map.set(state, jobs: [job | state.jobs])
    {:reply, {:ok, next_state}, next_state}
  end
end

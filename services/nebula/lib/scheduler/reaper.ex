defmodule Nebula.Scheduler.Reaper do
  use GenServer
  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, [], name: :reaper)
  end

  def init(jobs) do
    Process.send_after(self(), :work, 30_000)
    {:ok, jobs}
  end

  def handle_info(:work, state) do
    Logger.debug "[scheduler] Checking for Jobs to be reaped."

    # TODO get a list of all jobs here and work through them checking if any need to be shut down.
    #
    # Query Job table for jobs that are expired and kill them off:
    # `Nebula.Scheduler.Job.get(id)`

    Process.send_after(self(), :work, 30_000) # In 2 hours
    {:noreply, state}
  end
end

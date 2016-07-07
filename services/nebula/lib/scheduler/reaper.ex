defmodule Nebula.Scheduler.Reaper do
  import Ecto.Query, only: [from: 1, from: 2]
  use GenServer
  use Timex
  require Logger
  alias Nebula.Repo
  alias Ecto.Changeset

  def start_link do
    GenServer.start_link(__MODULE__, [], name: :reaper)
  end

  def init(jobs) do
    Process.send_after(self(), :work, 30_000)
    {:ok, jobs}
  end

  def handle_info(:work, state) do
    Logger.debug "[scheduler] Checking for Jobs to be reaped."

    expired_deploys |> Enum.map(fn(deploy) ->
      Logger.debug "[scheduler] Reaping #{deploy.slug}"
      Nomad.API.Job.delete(deploy.slug)
      Repo.update(Changeset.change(deploy, %{state: Deploy.states.dead}))
    end)

    Process.send_after(self(), :work, 30_000)
    {:noreply, state}
  end

  defp expired_deploys do
    query = from d in Nebula.Deploy, where: d.expire_at < ^DateTime.now, select: d
    Nebula.Repo.all(query)
  end
end

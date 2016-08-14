defmodule Nebula.Scheduler.Reaper do
  import Ecto.Query, only: [from: 1, from: 2]
  use GenServer
  use Timex
  require Logger
  alias Nebula.Repo
  alias Nebula.Deploy
  alias Ecto.Changeset

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
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
    Nebula.Repo.all(
      from d in Nebula.Deploy,
      where: d.expire_at < ^DateTime.utc_now and d.state == ^Deploy.states.running,
      select: d
    )
  end
end

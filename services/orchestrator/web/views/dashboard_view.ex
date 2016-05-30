defmodule Orchestrator.DashboardView do
  use Orchestrator.Web, :view
  alias Orchestrator.Deploy
  alias Orchestrator.Repo

  def deploys do
    Deploy |> Repo.all |> Repo.preload([:project])
  end
end

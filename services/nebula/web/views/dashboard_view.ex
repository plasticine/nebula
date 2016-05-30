defmodule Nebula.DashboardView do
  use Nebula.Web, :view
  alias Nebula.Deploy
  alias Nebula.Repo

  def deploys do
    Deploy |> Repo.all |> Repo.preload([:project])
  end
end

defmodule Nebula.DashboardView do
  use Nebula.Web, :view
  alias Nebula.Db.Deploy
  alias Nebula.Repo

  def deploys do
    Deploy
    |> Repo.all
    |> Repo.preload([:project])
  end
end

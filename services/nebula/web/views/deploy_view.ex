defmodule Nebula.DeployView do
  use Nebula.Web, :view
  alias Nebula.Deploy

  def web_url(deploy), do: Deploy.web_url(deploy)

  def allocations(deploy) do
    Nebula.Scheduler.Job.get_allocations(deploy.id)
  end

  def evaluations(deploy) do
    Nebula.Scheduler.Job.get_evaluations(deploy.id)
  end
end

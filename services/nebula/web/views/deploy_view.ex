defmodule Nebula.DeployView do
  use Nebula.Web, :view
  alias Nebula.Deploy

  def web_url(deploy), do: Deploy.web_url(deploy)

  def allocations(deploy) do
    case Nebula.Scheduler.Job.get_allocations(deploy.id) do
      {:ok, allocations} -> allocations
      {:error, _}        -> nil
    end
  end

  def evaluations(deploy) do
    case Nebula.Scheduler.Job.get_evaluations(deploy.id) do
      {:ok, evaluations} -> evaluations
      {:error, _}        -> nil
    end
  end
end

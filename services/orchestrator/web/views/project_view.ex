defmodule Orchestrator.ProjectView do
  use Orchestrator.Web, :view
  alias Orchestrator.Project

  def push_url(project) do
    Project.push_url(project)
  end
end

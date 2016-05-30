defmodule Nebula.ProjectView do
  use Nebula.Web, :view
  alias Nebula.Project

  def push_url(project) do
    Project.push_url(project)
  end
end

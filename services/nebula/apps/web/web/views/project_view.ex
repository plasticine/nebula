defmodule Nebula.Db.ProjectView do
  use Nebula.Web, :view
  alias Nebula.Db.Project

  def push_url(project), do: Project.push_url(project)
end

defmodule Orchestrator.ProjectType do
  alias Orchestrator.Repo
  alias Orchestrator.Project
  alias GraphQL.Type.{ObjectType, ID, String}

  def type do
    %ObjectType{
      name: "Project",
      description: "Project",
      fields: %{
        id: %{type: %ID{}},
        name: %{type: %String{}},
        slug: %{type: %String{}}
      }
    }
  end

  def resolve(_, %{id: id}, _), do: [Repo.get!(Project, id)]
  def resolve(_, _, _),         do: Repo.all(Project)
end

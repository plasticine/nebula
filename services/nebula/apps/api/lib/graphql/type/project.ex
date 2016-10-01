defmodule Nebula.GraphQL.Type.Project do
  alias Nebula.Db.Project
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

  def resolve(_, %{id: id}, _), do: [Nebula.Repo.get!(Project, id)]
  def resolve(_, _, _),         do: Nebula.Repo.all(Project)
end

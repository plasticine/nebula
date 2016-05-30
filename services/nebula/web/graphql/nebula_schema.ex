defmodule Nebula.NebulaSchema do
  alias GraphQL.Schema
  alias GraphQL.Type.ObjectType
  alias GraphQL.Type.List
  alias GraphQL.Type.NonNull
  alias GraphQL.Type.ID
  alias GraphQL.Type.String
  alias GraphQL.Type.Int
  alias GraphQL.Type.Boolean
  alias Nebula.NebulaSchema

  def schema do
    %Schema{
      query: %ObjectType{
        name: "Query",
        fields: %{
          project: %{
            type: %List{ofType: Nebula.ProjectType.type},
            args: %{id: %{type: %ID{}}},
            resolve: &Nebula.ProjectType.resolve/3
          }
        }
      }
    }
  end
end

defmodule Nebula.GraphQL.Schema do
  alias GraphQL.Schema
  alias GraphQL.Type.{ObjectType, ID, List}
  alias Nebula.GraphQL.Type.Project

  def schema do
    %Schema{
      query: %ObjectType{
        name: "Query",
        fields: %{
          project: %{
            type: %List{
              ofType: Project.type
            },
            args: %{
              id: %{
                type: %ID{}
              }
            },
            resolve: &Project.resolve/3
          }
        }
      }
    }
  end
end

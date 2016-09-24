defmodule GraphQL.Type.Union do
  @type t :: %GraphQL.Type.Union{
    name: binary,
    description: binary | nil,
    resolver: (any -> GraphQL.Type.ObjectType.t),
    types: [GraphQL.Type.ObjectType.t]
  }
  defstruct name: "", description: "", resolver: nil, types: []

  def new(map) do
    struct(GraphQL.Type.Union, map)
  end

  defimpl GraphQL.Type.AbstractType do
    @doc """
    Returns a boolean indicating if the typedef provided is part of the provided
    union type.
    """
    def possible_type?(union, object) do
      Enum.any?(union.types, fn(t) -> t.name === object.name end)
    end

    def possible_types(union, _schema) do
      union.types
    end

    @doc """
    Returns the typedef for the object that was passed in, which could be a
    struct or map.
    """
    def get_object_type(%{resolver: nil}=union, _, _) do
      throw "Missing 'resolver' field on Union #{union.name}"
    end
    def get_object_type(%{resolver: resolver}, object, _) do
      resolver.(object)
    end
  end

  defimpl String.Chars do
    def to_string(union), do: union.name
  end
end

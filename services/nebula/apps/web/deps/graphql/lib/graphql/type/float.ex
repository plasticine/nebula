defmodule GraphQL.Type.Float do
  @type t :: %GraphQL.Type.Float{name: binary, description: binary}
  defstruct name: "Float", description:
    """
    The `Float` scalar type represents signed double-precision fractional
    values as specified by [IEEE 754](http://en.wikipedia.org/wiki/IEEE_floating_point).
    """ |> GraphQL.Util.Text.normalize

  def coerce(false), do: 0
  def coerce(true), do: 1
  def coerce(value) when is_binary(value) do
    case Float.parse(value) do
      :error -> nil
      {v, _} -> coerce(v)
    end
  end
  def coerce(value) do
    value * 1.0
  end

  defimpl String.Chars do
    def to_string(_), do: "Float"
  end
end

defimpl GraphQL.Types, for: GraphQL.Type.Float do
  def parse_value(_, value), do: GraphQL.Type.Float.coerce(value)
  def serialize(_, value), do: GraphQL.Type.Float.coerce(value)
  def parse_literal(_, v), do: v.value
end

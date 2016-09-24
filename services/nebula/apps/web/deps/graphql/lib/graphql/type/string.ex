defmodule GraphQL.Type.String do
  defstruct name: "String", description:
    """
    The `String` scalar type represents textual data, represented as UTF-8
    character sequences. The String type is most often used by GraphQL to
    represent free-form human-readable text.
    """ |> GraphQL.Util.Text.normalize

  def coerce(nil), do: nil
  def coerce(value) when is_map(value) do
    for {k, v} <- value, into: %{}, do: {to_string(k), v}
  end
  def coerce(value), do: to_string(value)

  defimpl String.Chars do
    def to_string(_), do: "String"
  end
end

defimpl GraphQL.Types, for: GraphQL.Type.String do
  def parse_value(_, value), do: GraphQL.Type.String.coerce(value)
  def serialize(_, value), do: GraphQL.Type.String.coerce(value)
  def parse_literal(_, %{kind: :StringValue, value: value}), do: value
  def parse_literal(_, _), do: nil
end

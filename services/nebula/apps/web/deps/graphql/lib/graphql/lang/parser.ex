defmodule GraphQL.Lang.Parser do
  alias GraphQL.Lang.Lexer

  @moduledoc ~S"""
  GraphQL parser implemented with yecc.

  Parse a GraphQL query

      iex> GraphQL.parse "{ hello }"
      {:ok, %{definitions: [
        %{kind: :OperationDefinition, loc: %{start: 0},
          operation: :query,
          selectionSet: %{kind: :SelectionSet, loc: %{start: 0},
            selections: [
              %{kind: :Field, loc: %{start: 0}, name: "hello"}
            ]
          }}
        ],
        kind: :Document, loc: %{start: 0}
      }}
  """

  @doc """
  Parse the input string into a Document AST.

      iex> GraphQL.parse("{ hello }")
      {:ok,
        %{definitions: [
          %{kind: :OperationDefinition, loc: %{start: 0},
            operation: :query,
            selectionSet: %{kind: :SelectionSet, loc: %{start: 0},
              selections: [
                %{kind: :Field, loc: %{start: 0}, name: "hello"}
              ]
            }}
          ],
          kind: :Document, loc: %{start: 0}
        }
      }
  """
  @spec parse(String.t) :: {:ok, GraphQL.Document.t} | {:error, GraphQL.Errors.t}
  def parse(input_string) when is_binary(input_string) do
    input_string |> to_char_list |> parse
  end

  @spec parse(char_list) :: {:ok, GraphQL.Document.t} | {:error, GraphQL.Errors.t}
  def parse(input_string) do
    case input_string |> Lexer.tokenize |> :graphql_parser.parse do
      {:ok, parse_result} ->
        {:ok, parse_result}
      {:error, {line_number, _, errors}} ->
        {:error, %{errors: [
          %{"message" => "GraphQL: #{errors} on line #{line_number}", "line_number" => line_number}
        ]}}
    end
  end
end

defmodule GraphQL.Document do
  @moduledoc """
  Ddefines the structure of a GraphQL document after it has been parsed.
  """
  @type t :: %{definitions: list(Map), kind: atom, loc: Map}
  # defstruct [definitions: %{}, kind: :Document, loc: %{start: 0}]
end

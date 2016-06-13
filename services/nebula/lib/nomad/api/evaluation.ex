defmodule Nomad.API.Evaluation do
  use Nomad.API

  @endpoint "evaluation"

  @doc """
  Query a single evaluation.
  """
  @spec get(String.t) :: {:ok, String.t} | {:error, String.t}
  def get(id) do
    case get!(Path.join([@endpoint, id])) |> parse_response do
      {:ok, body} -> body
    end
  end

  @doc """
  Get the allocations for the evaluation.
  """
  def allocations(id) do
    case get!(Path.join([@endpoint, id, "allocations"])) |> parse_response do
      {:ok, allocations} -> Enum.map(allocations, fn x -> Nomad.Model.Allocation.from_map(x) end)
    end
  end
end

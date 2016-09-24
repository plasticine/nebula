defmodule Nomad.API.Job do
  use Nomad.API

  @endpoint "job"

  @doc """
  Query a single job for its specification and status.
  """
  def get(id) do
    get!(Path.join([@endpoint, id]))
  end

  @doc """
  Update an existing job.
  """
  def update(id, params) do
    raise "Not implemeted"
  end

  @doc """
  Register a new job.
  """
  def delete(id) do
    delete!(Path.join([@endpoint, id]))
  end

  # Get allocations for a job.
  def allocations(id) do
    case get!(Path.join([@endpoint, id, "allocations"])) |> parse_response do
      {:ok, body} -> Nomad.Model.Allocation.from_list(body)
    end
  end

  # Get evaluations for a job.
  def evaluations(id) do
    case get!(Path.join([@endpoint, id, "evaluations"]))  |> parse_response do
      {:ok, body} -> Nomad.Model.Evaluation.from_list(body)
    end
  end
end

defmodule Nomad.API.Jobs do
  use Nomad.API

  @endpoint "jobs"

  @doc """
  Lists all the jobs registered with Nomad.
  """
  def list do
    get!(@endpoint)
  end

  @doc """
  Register a new job.
  """
  @spec create(%{String.t => any}) :: {:ok, String.t} | {:error, String.t}
  def create(job) do
    case post!(@endpoint, Poison.encode!(job)) |> parse_response do
      {:ok, body} -> Nomad.Model.Job.from_map(body)
    end
  end
end

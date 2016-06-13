defmodule Nomad.API.Job do
  use Nomad.API

  @endpoint "job"

  @doc """
  Query a single job for its specification and status.
  """
  def get(id) do
    get!(@endpoint <> id)
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
    delete!(@endpoint <> id)
  end
end

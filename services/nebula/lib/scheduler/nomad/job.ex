defmodule Scheduler.Nomad.Job do
  use Scheduler.Nomad.HTTP

  @endpoint "job"

  @doc """
  Query a single job for its specification and status.
  """
  def get(id) do
    raise "Not implemeted"
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
    raise "Not implemeted"
  end
end

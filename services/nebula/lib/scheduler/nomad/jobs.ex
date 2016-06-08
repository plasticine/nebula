defmodule Scheduler.Nomad.Jobs do
  use Scheduler.Nomad.HTTP

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
  def create(job) do
    post!(@endpoint, job)
  end
end

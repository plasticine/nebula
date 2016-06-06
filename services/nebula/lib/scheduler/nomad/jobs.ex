defmodule Scheduler.Nomad.Jobs do
  use Scheduler.Nomad.HTTP

  @endpoint "jobs"

  @doc """
  Lists all the jobs registered with Nomad.
  """
  def list do
    get(@endpoint, "")
  end

  @doc """
  Register a new job.
  """
  def create(params) do
    raise "Not implemeted"
  end
end

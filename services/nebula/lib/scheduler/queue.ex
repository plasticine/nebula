defmodule Scheduler.Queue do
  use GenServer
  require Logger
  alias Scheduler.NomadBinary

  # GenServer initialization
  def start_link([]), do: GenServer.start_link(__MODULE__, [])
  def init([]), do: {:ok, %{jobs: []}}

  @doc """
  Register a new job to be scheduled.
  Saves the Job is a queue for later use.

  TODO: Doing all the things here and will plit up later...
  """
  def handle_call({:register, job}, _, state) do
    {:ok, pid} = GenServer.start_link(Scheduler.NomadBinary, job.spec)

    # TODO Add error handling here...
    {:ok, output} = NomadBinary.validate!(pid)
    {:ok, json} = NomadBinary.to_json!(pid)

    # Extract Job ID/name from json

    # Create Job, hold onto Evaluation ID
    Scheduler.Nomad.Jobs.create(json)


    next_state = Map.put(state, :jobs, [job | state.jobs])
    num_jobs = Enum.count(Map.get(next_state, :jobs))
    Logger.info "[Scheduler] Registered new Job, queue now has #{num_jobs} items."
    {:reply, {:ok, next_state}, next_state}
  end
end

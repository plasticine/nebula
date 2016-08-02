defmodule Nebula.Scheduler.Job do
  use GenServer
  require Logger

  def start_link(id) do
    GenServer.start_link(__MODULE__, id, name: via_tuple(id))
  end

  defp via_tuple(id) do
    {:via, :gproc, {:n, :l, {:job, id}}}
  end

  def init(id) do
    job = Nebula.Repo.get!(Nebula.Job, id) |> Nebula.Repo.preload(:deploy)
    state = %{job: job, evaluations: nil, allocations: nil}

    {:ok, state}
  end

  @doc """
  Register a new job to be scheduled.
  Saves the Job is a queue for later use.
  """
  def handle_cast(:start, state) do
    Logger.info "[scheduler] [job:#{state.job.id}] Starting new job '#{state.job.deploy.slug}'"

    # Parse nomad binary
    {:ok, pid} = GenServer.start_link(Nomad.Binary, state.job.spec)
    {:ok, output} = Nomad.Binary.validate!(pid)
    {:ok, job_spec} = Nomad.Binary.parse!(pid)

    # Create Job and get allocations.
    nebula_job = NebulaJob.rewrite_nomad_job!(job_spec, state.job.deploy.slug)
    nomad_job = Nomad.API.Jobs.create(nebula_job)

    # Start monitoring the job.
    :ok = Process.send(self(), :monitor, [])
    {:noreply, state, state}
  end

  @doc """
  Here we check the status of the job and monitor it's allocation and status.
  """
  def handle_info(:monitor, state) do
    Logger.info "[scheduler] [job:#{state.job.id}] Checking status of job..."

    state = %{state |
      evaluations: Nomad.API.Job.evaluations(state.job.deploy.slug),
      allocations: Nomad.API.Job.allocations(state.job.deploy.slug)
    }

    Process.send_after(self(), :monitor, 30_000)
    {:noreply, state}
  end

  @doc """
  Kill a job.
  """
  def handle_cast(:kill, state) do
    raise "Not implemeted"
  end

  def handle_call(:get_allocations, _from, state), do: {:reply, state.allocations, state}
  def handle_call(:get_evaluations, _from, state), do: {:reply, state.evaluations, state}

  @doc """
  Create new child process for the given Job, registering it's process with the
  scheduler process.
  """
  def create(job) when is_map(job), do: create(job.id)
  def create(id) do
    case Nebula.Scheduler.JobPool.start_job(id) do
      {:ok, child} ->
        GenServer.cast(child, :start)
        {:ok, child}
      {:error, error} ->
        Logger.error "[scheduler] Failed to create job [id:#{id}]"
        {:error, error}
    end
  end

  @doc """
  Find a job process by its Job id.
  """
  def get(id), do: :gproc.where({:n, :l, {:job, id}})

  @doc """
  Get allocation state for a job process by the Job ID.
  """
  def get_allocations(id), do: GenServer.call(get(id), :get_allocations)

  @doc """
  Get evvaluation state for a job process by the Job ID.
  """
  def get_evaluations(id), do: GenServer.call(get(id), :get_evaluations)
end

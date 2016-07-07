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
    {:ok, job}
  end

  @doc """
  Register a new job to be scheduled.
  Saves the Job is a queue for later use.
  """
  def handle_cast(:work, job) do
    {:ok, pid} = GenServer.start_link(Nomad.Binary, job.spec)

    # TODO Add error handling here...
    {:ok, output} = Nomad.Binary.validate!(pid)
    {:ok, job_spec} = Nomad.Binary.parse!(pid)

    nebula_job = NebulaJob.rewrite_nomad_job!(job_spec, job.deploy.slug)
    nomad_job = Nomad.API.Jobs.create(nebula_job)
    allocations = Nomad.API.Evaluation.allocations(nomad_job.eval_id)

    IO.inspect nomad_job
    IO.inspect allocations

    {:noreply, job, job}
  end

  @doc """
  Create new child process for the given Job, registering it's process with the
  scheduler process.
  """
  def create(job) do
    case Nebula.Scheduler.register_job(job.id) do
      {:ok, child} ->
        Logger.info "[scheduler] Created new Job [id:#{job.id}]"
        GenServer.cast(child, :work)
        {:ok, child}
      {:error, error} ->
        Logger.error "[scheduler] Failed to create job [id:#{job.id}]"
        {:error, error}
    end
  end

  @doc """
  Find a job process by its Job id.
  """
  def get(id), do: :gproc.where({:n, :l, {:job, id}})
end

defmodule Nomad.Model.Job do

  @type t :: %__MODULE__{}
  defstruct eval_create_index: nil, eval_id: nil, index: nil,
            job_modify_index: nil, known_leader: nil, last_contact: nil

  @spec from_map(%{String.t => any}) :: Nomad.Model.Job.t
  def from_map(job_map) do
    %__MODULE__{
      eval_create_index: job_map["EvalCreateIndex"],
      eval_id: job_map["EvalID"],
      index: job_map["Index"],
      job_modify_index: job_map["JobModifyIndex"],
      known_leader: job_map["KnownLeader"],
      last_contact: job_map["LastContact"]
    }
  end
end

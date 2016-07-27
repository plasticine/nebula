defmodule Nomad.Model.Allocation do
  alias Nomad.Model.TaskState

  @type t :: %__MODULE__{}
  defstruct id: nil, eval_id: nil, name: nil, node_id: nil, job_id: nil,
            task_group: nil, task_states: nil, desired_status: nil,
            desired_description: nil, client_status: nil, client_description: nil,
            create_index: nil, modify_index: nil

  def from_list(list) do
    Enum.map(list, &from_map/1)
  end

  @spec from_map(%{String.t => any}) :: Nomad.Model.Allocation.t
  def from_map(map) do
    %__MODULE__{
      id: map["ID"],
      eval_id: map["EvalID"],
      name: map["Name"],
      node_id: map["NodeID"],
      job_id: map["JobID"],
      task_group: map["TaskGroup"],
      task_states: task_states(map["TaskStates"]),
      desired_status: map["DesiredStatus"],
      desired_description: map["DesiredDescription"],
      client_status: map["ClientStatus"],
      client_description: map["ClientDescription"],
      create_index: map["CreateIndex"],
      modify_index: map["ModifyIndex"]
    }
  end

  defp task_states(nil), do: nil
  defp task_states(task_states) do
    task_states
    |> Enum.reject(&is_nil/1)
    |> Enum.map(fn({k,v}) -> {k, TaskState.from_map(v)} end)
  end
end

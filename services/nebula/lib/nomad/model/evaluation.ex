defmodule Nomad.Model.Evaluation do
  alias Nomad.Model.FailedTaskGroupAlloc

  @type t :: %__MODULE__{}
  defstruct annotate_plan: nil, blocked_eval: nil, class_eligibility: nil,
            create_index: nil, escaped_computed_class: nil, failed_task_group_allocs: nil,
            id: nil, job_id: nil, job_modify_index: nil, modify_index: nil,
            next_eval: nil, node_id: nil, node_modify_index: nil, previous_eval: nil,
            priority: nil, snapshot_index: nil, status: nil, status_description: nil,
            triggered_by: nil, type: nil, wait: nil

  def from_list(list) do
    Enum.map(list, &from_map/1)
  end

  @spec from_map(%{String.t => any}) :: Nomad.Model.Evaluation.t
  def from_map(map) do
    %__MODULE__{
      annotate_plan: map["AnnotatePlan"],
      blocked_eval: map["BlockedEval"],
      class_eligibility: map["ClassEligibility"],
      create_index: map["CreateIndex"],
      escaped_computed_class: map["EscapedComputedClass"],
      failed_task_group_allocs: failed_task_group_allocs(map["FailedTGAllocs"]),
      id: map["ID"],
      job_id: map["JobID"],
      job_modify_index: map["JobModifyIndex"],
      modify_index: map["ModifyIndex"],
      next_eval: map["NextEval"],
      node_id: map["NodeID"],
      node_modify_index: map["NodeModifyIndex"],
      previous_eval: map["PreviousEval"],
      priority: map["Priority"],
      snapshot_index: map["SnapshotIndex"],
      status: map["Status"],
      status_description: map["StatusDescription"],
      triggered_by: map["TriggeredBy"],
      type: map["Type"],
      wait: map["Wait"]
    }
  end

  defp failed_task_group_allocs(nil), do: nil
  defp failed_task_group_allocs(map) do
    Enum.reduce(map, %{}, fn ({key, val}, acc) ->
      Map.put(acc, key, FailedTaskGroupAlloc.from_map(val))
    end)
  end
end

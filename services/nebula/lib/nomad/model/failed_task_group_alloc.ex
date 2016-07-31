defmodule Nomad.Model.FailedTaskGroupAlloc do
  @type t :: %__MODULE__{}
  defstruct allocation_time: nil, class_exhausted: nil, class_filtered: nil,
            coalesced_failures: nil, constraint_filtered: nil, dimension_exhausted: nil,
            nodes_available: nil, nodes_evaluated: nil, nodes_exhausted: nil,
            nodes_filtered: nil, scores: nil

  @spec from_map(%{String.t => any}) :: Nomad.Model.FailedTaskGroupAlloc.t
  def from_map(map) do
    %__MODULE__{
      allocation_time: map["AllocationTime"],
      class_exhausted: map["ClassExhausted"],
      class_filtered: map["ClassFiltered"],
      coalesced_failures: map["CoalescedFailures"],
      constraint_filtered: map["ConstraintFiltered"],
      dimension_exhausted: map["DimensionExhausted"],
      nodes_available: map["NodesAvailable"],
      nodes_evaluated: map["NodesEvaluated"],
      nodes_exhausted: map["NodesExhausted"],
      nodes_filtered: map["NodesFiltered"],
      scores: map["Scores"]
    }
  end
end

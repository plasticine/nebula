defmodule Nomad.Model.TaskState do
  alias Nomad.Model.Event

  @type t :: %__MODULE__{}
  defstruct state: nil, events: nil

  def from_list(list) do
    Enum.map(list, fn({k, v}) -> {k, from_map(v)} end)
  end

  @spec from_map(%{String.t => any}) :: Nomad.Model.TaskState.t
  def from_map(map) do
    %__MODULE__{
      state: map["State"],
      events: events(map)
    }
  end

  defp events(map) do
    map
    |> Map.get("Events")
    |> Enum.map(&Event.from_map/1)
  end
end

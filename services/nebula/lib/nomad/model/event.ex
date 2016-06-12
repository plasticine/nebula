defmodule Nomad.Model.Event do
  @type t :: %__MODULE__{}
  defstruct download_error: nil, driver_error: nil, exit_code: nil, kill_error: nil,
            message: nil, restart_reason: nil, signal: nil, start_delay: nil,
            time: nil, type: nil, validation_error: nil

  @spec from_map(%{String.t => any}) :: Nomad.Model.Event.t
  def from_map(map) do
    %__MODULE__{
      download_error: map["DownloadError"],
      driver_error: map["DriverError"],
      exit_code: map["ExitCode"],
      kill_error: map["KillError"],
      message: map["Message"],
      restart_reason: map["RestartReason"],
      signal: map["Signal"],
      start_delay: map["StartDelay"],
      time: map["Time"],
      type: map["Type"],
      validation_error: map["ValidationError"]
    }
  end
end

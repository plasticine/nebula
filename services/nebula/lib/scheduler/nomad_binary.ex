defmodule Scheduler.NomadBinary do
  @doc """
  Module defining functionality for interacting with the Nomad binary.
  """

  use GenServer
  require Logger

  def start_link(spec) do
    GenServer.start_link(__MODULE__, spec)
  end

  def init(spec) do
    {:ok, spec_file} = Temp.open("nomad_binary", &IO.write(&1, spec))
    {:ok, %{spec_file: spec_file, nomad_executable: find_nomad_executable!}}
  end

  @doc """
  Validate the give Job spec.

  Nomad does not support validating files via STDIN, so we need to write to a
  temp file and validate that instead.
  """
  @spec validate!(pid) :: {:ok, String.t} | {:error, String.t}
  def validate!(pid) do
    case GenServer.call(pid, :validate) do
      {:ok, output}    -> {:ok, "Job validation successful"}
      {:error, output} -> {:error, "The Job is invalid: " <> output}
    end
  end

  @doc """
  Convert a HCL Job spec to JSON.
  """
  @spec to_json!(pid) :: {:ok, String.t} | {:error, any}
  def to_json!(pid) do
    case GenServer.call(pid, :to_json) do
      {:ok, json}      -> {:ok, json}
      {:error, output} -> {:error, output}
    end
  end

  def handle_call(:validate, _, state) do
    case System.cmd state.nomad_executable, ["validate", state.spec_file] do
      {output, 0} -> {:reply, {:ok, output}, state}
      {output, _} -> {:reply, {:error, output}, state}
    end
  end

  def handle_call(:to_json, _, state) do
    case System.cmd state.nomad_executable, ["run", "-output", state.spec_file] do
      {output, 0} -> {:reply, {:ok, output}, state}
      {output, _} -> {:reply, {:error, output}, state}
    end
  end

  defp find_nomad_executable! do
    case System.find_executable("nomad") do
      nil  -> throw "Could not locate Nomad binary."
      path -> path
    end
  end
end

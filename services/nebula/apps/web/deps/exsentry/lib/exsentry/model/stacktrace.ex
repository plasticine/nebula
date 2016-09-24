defmodule ExSentry.Model.Stacktrace do
  @moduledoc false

  # ExSentry.Model.Stacktrace represents an object adhering to the Sentry
  # `stacktrace` interface.

  @derive [Poison.Encoder]

  defstruct frames: nil

  @doc ~S"""
  Returns an ExSentry.Model.Stacktrace based on the given Erlang/Elixir
  stacktrace (as returned by `System.stacktrace/0`).
  """
  @spec from_stacktrace([tuple]) :: %ExSentry.Model.Stacktrace{}
  def from_stacktrace(%ExSentry.Model.Stacktrace{}=trace), do: trace
  def from_stacktrace(stacktrace) do
    frames = stacktrace |> Enum.map(&format_stacktrace_entry(&1))
    %ExSentry.Model.Stacktrace{frames: frames}
  end

  @spec format_stacktrace_entry(tuple) :: map
  defp format_stacktrace_entry(entry) do
    case entry do
      {module, fname, arity, file_and_line} ->
        arity = if is_list(arity), do: Enum.count(arity), else: arity
        Map.merge(file_and_line_map(file_and_line), %{
          function: "#{fname}/#{arity}",
          module: module,
        })
    end
  end

  @spec file_and_line_map([atom: any]) :: map
  defp file_and_line_map(file_and_line_dict) do
    file = file_and_line_dict[:file]
    line = file_and_line_dict[:line]
    cond do
      file && line -> %{filename: to_string(file), lineno: line}
      file -> %{filename: to_string(file)}
      line -> %{lineno: line}
      true -> %{}
    end
  end
end

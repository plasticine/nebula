defmodule ExSentry.Utils do
  require Logger

  @moduledoc false

  @doc ~S"""
  Attempts to execute `fun`. If an exception is raised, it is caught and
  printed to the error log.
  """
  def safely_do(fun) do
    try do
      fun.()
    rescue
      e ->
        Exception.format(:error, e) |> Logger.error
        {:error, e}
    end
  end

  @doc ~S"""
  Returns the string-formatted version of the given app.
  """
  @spec version(atom) :: String.t
  def version(app \\ :exsentry) do
    versions[app]
  end

  @doc ~S"""
  Returns a map of {app: version} pairs.
  """
  @spec versions :: map
  def versions do
    Enum.reduce Application.loaded_applications, %{}, fn ({app, _desc, ver}, acc) ->
      Map.put(acc, app, to_string(ver))
    end
  end

  @doc ~S"""
  Given a list of {headername, value} tuples, returns a map of
  %{headername => merged_values} pairs suitable for inclusion in a
  Sentry "Http" object as `headers`.

      iex> headers = [{"header1", "value1"}, {"header2", "value2"}, {"header1", "value3"}]
      iex> headers |> ExSentry.Utils.merge_http_headers
      %{"header1" => "value1, value3", "header2" => "value2"}
  """
  @spec merge_http_headers([{String.t, String.t}]) :: map
  def merge_http_headers(headers) do
    Enum.reduce headers, %{}, fn ({key, value}, acc) ->
      if Map.has_key?(acc, key) do
        oldval = Map.get(acc, key)
        Map.put(acc, key, "#{oldval}, #{value}")
      else
        Map.put(acc, key, value)
      end
    end
  end

  @doc ~S"""
  Merges two maps of tags, returning a JSON-compatible structure like
  [ [tag1, value1], [tag2, value2], ... ].  Allows duplicates.

      iex> t1 = %{a: 1, b: 2}
      iex> t2 = %{a: 3}
      iex> ExSentry.Utils.merge_tags(t1, t2)
      [[:a, 1], [:b, 2], [:a, 3]]
  """
  @spec merge_tags(map, map) :: [[atom: any]]
  def merge_tags(global_tags, tags) do
    (Map.to_list(global_tags) ++ Map.to_list(tags))
    |> Enum.map(fn ({k, v}) -> [k, v] end)
  end

  @doc ~S"""
  Returns the number of seconds since the Unix epoch.
  """
  @spec unixtime :: integer
  def unixtime do
    {mega, sec, _microsec} = :os.timestamp
    mega * 1000000 + sec
  end

  @doc ~S"""
  Returns a copy of `map` with all nil values (and their keys) removed.

      iex> %{a: 1, b: nil, c: 3} |> ExSentry.Utils.strip_nils_from_map
      %{a: 1, c: 3}
  """
  @spec strip_nils_from_map(map) :: map
  def strip_nils_from_map(map) do
    Enum.reduce map, %{}, fn ({k,v}, acc) ->
      if is_nil(v), do: acc, else: Map.put(acc, k, v)
    end
  end
end


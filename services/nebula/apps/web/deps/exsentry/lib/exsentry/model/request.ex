defmodule ExSentry.Model.Request do
  @moduledoc false

  # ExSentry.Model.Request represents an object adhering to the Sentry
  # `request` interface.

  @derive [Poison.Encoder]

  defstruct url: nil,
            method: nil,
            data: nil,
            query_string: nil,
            headers: nil,
            cookies: nil,
            env: nil

  @doc ~S"""
  Returns a JSON-compatible map describing the given `conn`, adhering
  to the Sentry "Http" interface.
  """
  @spec from_conn(%Plug.Conn{}) :: %ExSentry.Model.Request{}
  def from_conn(conn) do
    {:ok, data, _conn} = Plug.Conn.read_body(conn, length: 8192)
    headers = conn.req_headers |> ExSentry.Utils.merge_http_headers
    cookies = case conn.req_cookies do
                %Plug.Conn.Unfetched{} ->
                  (conn |> Plug.Conn.fetch_cookies).req_cookies
                c ->
                  c
              end
    %ExSentry.Model.Request{
      url: conn.request_path,
      method: conn.method,
      data: data,
      query_string: conn.query_string,
      headers: headers,
      cookies: cookies,
      env: %{
        remote_ip: conn.remote_ip |> format_ip
      }
    }
  end

  @spec format_ip(tuple) :: String.t
  defp format_ip({a, b, c, d}), do: "#{a}.#{b}.#{c}.#{d}"

end


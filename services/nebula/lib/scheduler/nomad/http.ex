defmodule Scheduler.Nomad.HTTP do
  defmacro __using__(_) do
    quote do
      use HTTPoison.Base

      @api_version "v1"

      defp get(endpoint, body) do
        make_request(:get, endpoint, body)
      end

      defp post(endpoint, body) do
        make_request(:post, endpoint, body)
      end

      defp put(endpoint, body) do
        make_request(:put, endpoint, body)
      end

      defp make_request(method, endpoint, body \\ [], headers \\ [], options \\ []) do
        Path.join([Scheduler.Nomad.node_address, @api_version, endpoint])
        |> IO.inspect

        # {:ok, response} = request(method, endpoint, rb, rh, options)
      end
    end
  end
end

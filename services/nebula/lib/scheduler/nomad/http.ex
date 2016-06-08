defmodule Scheduler.Nomad.HTTP do
  defmacro __using__(_) do
    quote do
      use HTTPoison.Base

      @api_version "v1"

      @spec process_url(binary) :: binary
      def process_url(endpoint) do
        Path.join([Scheduler.Nomad.node_address, @api_version, endpoint])
      end

      @doc """
      Converts the binary keys in our response to atoms.
      """
      def process_response_body(body) do
        Poison.decode! body
      end
    end
  end
end

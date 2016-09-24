defmodule Nomad.API do
  defmacro __using__(_) do
    quote do
      use HTTPoison.Base

      @api_version "v1"

      @spec process_url(binary) :: binary
      def process_url(path), do:  Path.join([Nomad.node_address, @api_version, path])

      @doc """
      Converts the binary keys in our response to atoms.
      """
      def process_response_body(body), do: Poison.decode! body

      @doc """
      Parse the response from HTTPoision
      """
      def parse_response(response) do
        cond do
          response.status_code in 200..299 -> {:ok, response.body}
          response.status_code in 400..499 -> {:error, response.body}
          # % HTTPoison.Error{reason: _}      -> {:error, response.reason}
        end
      end
    end
  end
end

defmodule Scheduler.Nomad do
  @moduledoc """
  A client for consuming the Nomad HTTP API.
  """

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def init([]) do
    {:ok, []}
  end

  def node_address do
    "http://nomad:4646"
  end
end

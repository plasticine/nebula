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
    "http://172.20.10.10"
  end
end

defmodule Nebula.Scheduler.Supervisor do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(Nebula.Scheduler, []),
      worker(Nebula.Scheduler.Reaper, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Nebula.Scheduler.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

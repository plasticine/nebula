defmodule ExSentry do
  @moduledoc ~s"""
  ExSentry is an Elixir interface to the Sentry error reporting platform.

  ## Installation

  1. Add ExSentry to your list of dependencies in `mix.exs`:

          def deps do
            [{:exsentry, "~> #{ExSentry.Mixfile.project[:version]}"}]
          end

  2. Ensure ExSentry is started and packaged with your application,
     in `mix.exs`:

          def application do
            [applications: [:exsentry]]
          end

  3. Configure the default ExSentry client by specifying your Sentry DSN
     in `config.exs`:

          config :exsentry, dsn: "your-dsn-here"

     To turn ExSentry off for a particular `MIX_ENV`, set the Sentry
     DSN to the empty string `""` in the appropriate config file.


  ## Typical usage

  Use `ExSentry.LoggerBackend` to send all `:error`-level log messages
  to Sentry:

      defmodule Myapp do
        use Application

        def start(_type, _args) do
          Logger.add_backend(ExSentry.LoggerBackend)
          # ...
        end

        # ...
      end

  Use `ExSentry.Plug` to capture all exceptions in a Plug pipeline:

      # Phoenix example
      defmodule Myapp.Router do
        use Myapp.Web, :router
        use ExSentry.Plug

        pipeline :browser do
          # ...


      # pure Plug example
      defmodule Myapp.Router do
        use Plug.Router
        use ExSentry.Plug

        get "/" do
          # ...

  Use `ExSentry` by itself to send exception or message data to Sentry:

      ExSentry.capture_message("Hello world!")

      ExSentry.capture_exception(an_exception)

      ExSentry.capture_exceptions fn ->
        something_that_might_raise()
      end


  ## Standalone usage

  ExSentry can be used as a manually-configured standalone client.

  Create a client process like this:

      client = ExSentry.new("your-dsn-here")

  And capture messages or exceptions like this:

      client |> ExSentry.capture_message("Hello world!")

      client |> ExSentry.capture_exception(an_exception)

      client |> ExSentry.capture_exceptions fn ->
        something_that_might_raise()
      end


  ## Authorship and License

  ExSentry is copyright 2015-2016 Appcues, Inc.

  ExSentry is released under the
  [MIT License](https://github.com/appcues/exsentry/blob/master/LICENSE.txt).
  """


  @doc ~S"""
  Starts a Sentry client, and returns the PID of the client process.
  """
  @spec new(String.t, [atom: any]) :: GenServer.server
  def new(dsn, opts \\ []) do
    {:ok, pid} = GenServer.start_link(ExSentry.Client, %{dsn: dsn, opts: opts})
    pid
  end


  @doc ~S"""
  Sends a message to Sentry, using the given client and options.
  """
  @spec capture_message(GenServer.server, String.t, [atom: any]) :: :ok
  def capture_message(client, message, opts) do
    GenServer.cast(client, {:capture_message, message, opts})
  end

  @doc ~S"""
  Sends a message to Sentry, using the default client and given options.
  """
  @spec capture_message(String.t, [atom: any]) :: :ok
  def capture_message(message, opts) when is_list(opts) do
    capture_message(:exsentry_default_client, message, opts)
  end

  @doc ~S"""
  Sends a message to Sentry, using the given client.
  """
  @spec capture_message(GenServer.server, String.t) :: :ok
  def capture_message(client, message) do
    capture_message(client, message, [])
  end

  @doc ~S"""
  Sends a message to Sentry, using the default client.
  """
  @spec capture_message(String.t) :: :ok
  def capture_message(message) do
    capture_message(:exsentry_default_client, message, [])
  end


  @doc ~S"""
  Sends an exception to Sentry, using the given client and options.

  Pass an Erlang stacktrace as `opts[:stacktrace]` to override
  the default `System.stacktrace` behavior.
  """
  @spec capture_exception(GenServer.server, Exception.t, [atom: any]) :: :ok
  def capture_exception(client, exception, opts) do
    trace = opts[:stacktrace] || (System.stacktrace |> Enum.drop(1))
    GenServer.cast(client, {:capture_exception, exception, trace, opts})
  end

  @doc ~S"""
  Sends an exception to Sentry, using the default client and given options.
  """
  @spec capture_exception(Exception.t, [atom: any]) :: :ok
  def capture_exception(exception, opts) when is_list(opts) do
    capture_exception(:exsentry_default_client, exception, opts)
  end

  @doc ~S"""
  Sends an exception to Sentry, using the given client.
  """
  @spec capture_exception(GenServer.server, Exception.t) :: :ok
  def capture_exception(client, exception) do
    capture_exception(client, exception, [])
  end

  @doc ~S"""
  Sends an exception to Sentry, using the default client.
  """
  @spec capture_exception(Exception.t) :: :ok
  def capture_exception(exception) do
    capture_exception(:exsentry_default_client, exception, [])
  end


  @doc ~S"""
  Using the given client and options, runs the given function, sending
  any exception to Sentry. Does not rescue the exception.
  """
  @spec capture_exceptions(GenServer.server, [atom: any], (() -> any)) :: any
  def capture_exceptions(client, opts, fun) do
    try do
      fun.()
    rescue
      e ->
        capture_exception(client, e, opts)
        raise e
    end
  end

  @doc ~S"""
  Using the default client and given options, runs the given function, sending
  any exception to Sentry. Does not rescue the exception.
  """
  @spec capture_exceptions([atom: any], (() -> any)) :: any
  def capture_exceptions(opts, fun) when is_list(opts) do
    capture_exceptions(:exsentry_default_client, opts, fun)
  end

  @doc ~S"""
  Using the given client, runs the given function, sending
  any exception to Sentry. Does not rescue the exception.
  """
  @spec capture_exceptions(GenServer.server, (() -> any)) :: any
  def capture_exceptions(client, fun) do
    capture_exceptions(client, [], fun)
  end

  @doc ~S"""
  Using the default client, runs the given function, sending
  any exception to Sentry. Does not rescue the exception.
  """
  @spec capture_exceptions((() -> any)) :: any
  def capture_exceptions(fun) do
    capture_exceptions(:exsentry_default_client, [], fun)
  end


  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(Exsentry.Worker, [arg1, arg2, arg3]),
      worker(ExSentry.Client, [[name: :exsentry_default_client]])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExSentry.Supervisor]
    Supervisor.start_link(children, opts)
  end

end


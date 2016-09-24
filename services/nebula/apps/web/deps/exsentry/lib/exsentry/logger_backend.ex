defmodule ExSentry.LoggerBackend do
  @moduledoc ~S"""
  `ExSentry.LoggerBackend` is a backend for the Elixir `Logger` app.
  It captures all log messages above a given severity level (default `:error`)
  with `ExSentry.capture_message`.

  ## Usage

  1. Install the logger backend with:

          Logger.add_backend(ExSentry.LoggerBackend)

     or, in `mix.exs`:

          # Warning! Removes other configured backends!
          config :logger, backends: [ExSentry.LoggerBackend]

  2. (Optional) Configure the log level with:

          Logger.configure_backend(ExSentry.LoggerBackend, level: :warn)

     or, in `mix.exs`:

          config :exsentry, :logger_backend, level: :warn

  ## Available configuration parameters

  * `:level` - Sets log level to `level` and above.  Atom.
  * `:log_levels` - Sets log levels specifically; supersedes `:level`.
     List of atoms.
  """

  use GenEvent

  defmodule State do
    @moduledoc false

    @levels %{
      error: [:error],
      warn:  [:error, :warn],
      info:  [:error, :warn, :info],
      debug: [:error, :warn, :info, :debug]
    }

    defstruct log_levels: @levels.error

    def new(opts \\ []), do: %__MODULE__{} |> set(opts)

    def set(%__MODULE__{}=state, opts) do
      log_levels = opts[:log_levels] || @levels[opts[:level]] || state.log_levels
      %{state | log_levels: log_levels}
    end
  end

  @doc false
  def init(_) do
    {:ok, State.new(
      level: get_config(:level),
      log_levels: get_config(:log_levels),
    )}
  end

  @doc false
  def handle_call({:configure, opts}, %State{}=state) do
    {:ok, :ok, State.set(state, opts)}
  end

  @doc false
  def handle_event({level, _gl, {Logger, msg, _ts, _md}}, %State{}=state) do
    ## The lack of "when node(gl) == node()" is deliberate.  I'd rather
    ## ExSentry tend toward over-reporting rather than potentially miss
    ## valuable crash information from another node.

    if level in state.log_levels, do: ExSentry.capture_message(msg)

    {:ok, state}
  end

  @doc false
  def handle_event(_event, %State{}=state) do
    {:ok, state}
  end


  defp get_config(key) do
    Application.get_env(:exsentry, :logger_backend, []) |> Keyword.get(key)
  end
end


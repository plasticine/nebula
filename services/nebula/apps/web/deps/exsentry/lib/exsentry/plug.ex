defmodule ExSentry.Plug do
  @moduledoc ~S"""
  ExSentry.Plug is a Plug error handler which can be used to automatically
  intercept and report to Sentry any exceptions encountered by a Plug-based
  web application.

  To use, configure `mix.exs` and `config.exs` as described in README.md,
  then add `use ExSentry.Plug` near the top of your webapp's plug stack,
  for example:

      defmodule MyApp.Router do
        use MyApp.Web, :router
        use ExSentry.Plug

        pipeline :browser do
        ...

  Available options:

  * `exception_whitelist` (list of modules) skips reporting on the given
    exception types

         use ExSentry.Plug, exception_whitelist: [ArgumentError]

  * `plug_status_whitelist` (list of integers) skips reporting on exception
    types with the given Plug status

         use ExSentry.Plug, plug_status_whitelist: [401, 403, 404]
  """

  @doc false
  defmacro __using__(opts) do
    quote do
      use Plug.ErrorHandler

      ## Ignore missing Plug and Phoenix routes
      defp handle_errors(_conn, %{reason: %FunctionClauseError{function: :do_match}}) do
        nil
      end
      if :code.is_loaded(Phoenix) do
        defp handle_errors(_conn, %{reason: %Phoenix.Router.NoRouteError{}}) do
          nil
        end
      end

      defp handle_errors(conn, %{reason: exception, stack: stack}=args) do
        ExSentry.Plug.handle_errors(conn, args, unquote(opts))
      end
    end
  end

  @doc false
  @spec handle_errors(%Plug.Conn{}, map, [{atom, any}]) :: :ok
  def handle_errors(conn, %{reason: exception, stack: stack}, opts \\ []) do
    with_whitelists opts, exception, fn ->
      req = ExSentry.Model.Request.from_conn(conn)
      st = ExSentry.Model.Stacktrace.from_stacktrace(stack)
      ExSentry.capture_exception(exception, request: req, stacktrace: st)
    end
    :ok
  end

  @doc false
  @spec with_whitelists([{atom, any}], %{}, function) :: any
  def with_whitelists(opts, exception, func) do
    ew = opts[:exception_whitelist] || []
    psw = opts[:plug_status_whitelist] || []
    status = Plug.Exception.status(exception)
    if !(status in psw) && !(exception.__struct__ in ew) do
      func.()
    else
      :whitelisted
    end
  end
end


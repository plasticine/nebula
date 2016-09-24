defmodule ExSentry.Model.User do
  @moduledoc false

  # ExSentry.Model.User represents an object adhering to the Sentry
  # `user` interface.

  @derive [Poison.Encoder]

  defstruct id: nil,
            username: nil,
            email: nil,
            ip_address: nil,
            attributes: nil
end


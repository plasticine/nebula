defmodule Nebula.Api.Router do
  use Nebula.Api.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Nebula.Api do
    pipe_through :api
  end

  scope "/graphql" do
    pipe_through :api

    forward "/", GraphQL.Plug, schema: {Nebula.GraphQL.Schema, :schema}
  end
end

defmodule Nebula.Api.Router do
  use Nebula.Api.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Nebula.Api, as: :api do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      scope "/deploy" do
        resources "/", DeployController do
          resources "/job", JobController, only: [:create, :show], singleton: true
        end
      end
    end
  end

  scope "/graphql" do
    pipe_through :api

    forward "/", GraphQL.Plug, schema: {Nebula.GraphQL.Schema, :schema}
  end
end

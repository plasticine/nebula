defmodule Nebula.Router do
  use Nebula.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/graphql" do
    pipe_through :api

    forward "/", GraphQL.Plug, schema: {Nebula.NebulaSchema, :schema}
  end

  scope "/", Nebula do
    pipe_through :browser # Use the default browser stack

    get "/", DashboardController, :index
    resources "/projects", ProjectController
    resources "/logs", LogController
  end

  scope "/api", Nebula.Api, as: :api do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      scope "/deployment" do
        resources "/", DeploymentController
      end
    end
  end
end

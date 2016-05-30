defmodule Nebula.Api.V1.DeploymentView do
  use Nebula.Web, :view
  alias Nebula.Api.V1.DeploymentView

  @attributes ~w(
    id
    ref
    rev
    inserted_at
    updated_at
    state
    slug
  )a

  def render("index.json", %{deployments: deployments}) do
    %{deployments: render_many(deployments, DeploymentView, "deployment.json")}
  end

  def render("show.json", %{deployment: deployment}) do
    render_one(deployment, DeploymentView, "deployment.json")
  end

  def render("deployment.json", %{deployment: deployment}) do
    deployment
    |> Map.take(@attributes)
  end
end

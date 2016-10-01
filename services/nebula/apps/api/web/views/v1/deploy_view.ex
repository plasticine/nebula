defmodule Nebula.Api.V1.DeployView do
  use Nebula.Api.Web, :view
  alias Nebula.Api.V1.DeployView

  @attributes ~w(
    id
    ref
    rev
    inserted_at
    updated_at
    expire_at
    state
    slug
  )a

  def render("index.json", %{deploys: deploys}) do
    %{deploys: render_many(deploys, DeployView, "deploy.json")}
  end

  def render("show.json", %{deploy: deploy}) do
    render_one(deploy, DeployView, "deploy.json")
  end

  def render("deploy.json", %{deploy: deploy}) do
    deploy
    |> Map.take(@attributes)
  end
end

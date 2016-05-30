defmodule Nebula.HaproxyView do
  use Nebula.Web, :view
  alias Nebula.Deploy
  alias Nebula.Repo

  def deploys do
    Deploy |> Repo.all
  end

  def hostname(deploy) do
    deploy.slug <> ".sploosh.cool"
  end

  def host_address(backend) do
    "1.2.3.4:80"
  end

  def backend_for(deploy) do
    case deploy.state do
      "ready" -> backend_name(deploy)
      _       -> "web"
    end
  end

  def backend_name(deploy) do
    deploy.slug
  end
end

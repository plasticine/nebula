defmodule Nebula.DeployView do
  use Nebula.Web, :view
  alias Nebula.Deploy

  def web_url(deploy), do: Deploy.web_url(deploy)
end

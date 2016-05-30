defmodule DeployManager.Haproxy do
  alias DeployManager.Haproxy
  alias Nebula.Deploy
  alias Phoenix.View

  @config_file_path "/container/haproxy/conf/haproxy.cfg"

  def regenerate! do
    config = Phoenix.View.render_to_iodata(Nebula.HaproxyView, "haproxy.cfg", %{})
    case File.write(@config_file_path, config) do
      :ok              -> {:ok, config}
      {:error, reason} -> {:error, reason}
    end
  end
end

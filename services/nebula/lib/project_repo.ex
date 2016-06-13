defmodule ProjectRepo do
  require Logger

  def init!(project) do
    case bootstrap_repo(project) do
      {output, 0} ->
        Logger.info(output)
        project
      {error, _exit_code} ->
        Logger.error(error)
        {:error, error}
    end
  end

  def delete!(project) do
    File.rm_rf!(repo_path(project.slug))
  end

  defp bootstrap_repo(project) do
    root = repo_path(project.slug)

    case init_repo(root) do
      {output, 0} ->
        link_hooks(root)
        set_hook_permissions(root)
        create_project_config(root, project)
        {output, 0}
      {error, exit_code} ->
        {error, exit_code}
    end
  end

  defp repo_path(slug) do
    "/data/git/" <> slug <> ".git"
  end

  defp init_repo(root) do
    System.cmd(git, ["init", "--bare", root])
  end

  defp link_hooks(root) do
    File.ln_s("/etc/git/hooks/post-receive", Path.join([root, "hooks", "post-receive"]))
  end

  defp set_hook_permissions(root) do
    File.chmod(Path.join([root, "hooks", "post-receive"]), 0o755)
  end

  defp create_project_config(root, project) do
    File.write!(Path.join(root, "nebula_config"), Enum.join(["NEBULA_PROJECT_ID", project.id], "=") <> "\n")
  end

  defp git do
    System.find_executable("git")
  end
end

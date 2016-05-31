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
    repo_path(project.slug) |> File.rm_rf!
  end

  defp bootstrap_repo(project) do
    repo_root = repo_path(project.slug)

    case init_repo(repo_root) do
      {output, 0} ->
        set_hook_permissions(repo_root)
        create_project_config(repo_root, project)
        {output, 0}
      {error, exit_code} ->
        {error, exit_code}
    end
  end

  defp repo_path(slug) do
    "/container/git/data/" <> slug <> ".git"
  end

  defp init_repo(path) do
    System.cmd(git, ["init", "--bare", "--template=/container/git/templates/repo", path])
  end

  defp set_hook_permissions(root) do
    File.chmod(Path.join([root, "hooks", "post-receive"]), 0o755)
  end

  defp create_project_config(root, project) do
    File.write!(Path.join(root, "nebula_config"), Enum.join(["NEBULA_PROJECT_ID", project.id], "="))
  end

  defp git do
    System.find_executable("git")
  end
end

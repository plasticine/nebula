defmodule NebulaJob do

  @doc """
  Rewrites a job specification JSON Map into something that nebula can track.

  Changes names of the Job, Task Groups and Tasks, and discovers entrypoints tags
  for Nebula and adds hooks for Fabio to discover these entrypoint Services.

  TODO: this should throw on failure.
  """
  def rewrite_nomad_job!(job_spec, slug) do
    job_spec
    |> update_nebula_entrypoint_service(slug)
    |> update_job_name(slug)
    |> update_job_id(slug)
  end

  defp update_job_id(job_spec, slug) do
    put_in(job_spec, ["Job", "ID"], slug)
  end

  defp update_job_name(job_spec, slug) do
    put_in(job_spec, ["Job", "Name"], slug)
  end

  defp update_nebula_entrypoint_service(job_spec, slug) do
    update_in(job_spec, ["Job", "TaskGroups", &items/3], fn(group) ->
      update_in(group, ["Tasks", &items/3], fn(task) ->
        update_in(task, ["Services", &items/3], update_service(task, group, slug))
      end)
    end)
  end

  defp update_service(task, group, slug), do: &update_service(&1, task, group, slug)
  defp update_service(service, task, group, slug) do
    service_name = service_name(task, group, slug)

    service
    |> put_in(["Name"], service_name)
    |> update_in(["Checks", &items/3], update_service_checks(service_name))
    |> update_in(["Tags"], update_service_tags(slug))
  end

  defp update_service_tags(slug), do: &update_service_tags(&1, slug)
  defp update_service_tags(nil, slug), do: nil
  defp update_service_tags(tags, slug) when is_list(tags) do
    if Enum.member?(tags, "nebula-entrypoint") do
      [urlprefix_for_slug(slug) | tags]
    else
      tags
    end
  end

  defp update_service_checks(name), do: &update_service_checks(&1, name)
  defp update_service_checks(checks, service_name) do
    put_in(checks, ["Name"], "service: '#{service_name}' check")
  end

  defp service_name(group, task, slug) do
    [slug, Map.get(group, "Name"), Map.get(task, "Name")]
    |> Enum.map(&String.downcase/1)
    |> Enum.join("-")
  end

  defp urlprefix_for_slug(slug), do: "urlprefix-#{slug}.#{host}/"
  defp host, do: "nebula.dev:9999"  # TODO read this from config

  defp items(:get_and_update, data, next), do: Enum.map(data, next) |> :lists.unzip
end

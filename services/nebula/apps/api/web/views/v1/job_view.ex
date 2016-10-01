defmodule Nebula.Api.V1.JobView do
  use Nebula.Api.Web, :view

  def render("index.json", %{jobs: jobs}) do
    %{data: render_many(jobs, Nebula.Api.V1.JobView, "job.json")}
  end

  def render("show.json", %{job: job}) do
    %{data: render_one(job, Nebula.Api.V1.JobView, "job.json")}
  end

  def render("job.json", %{job: job}) do
    %{id: job.id,
      spec: job.spec,
      deploy_id: job.deploy_id}
  end
end

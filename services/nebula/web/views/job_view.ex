defmodule Nebula.JobView do
  use Nebula.Web, :view

  def render("index.json", %{jobs: jobs}) do
    %{data: render_many(jobs, Nebula.JobView, "job.json")}
  end

  def render("show.json", %{job: job}) do
    %{data: render_one(job, Nebula.JobView, "job.json")}
  end

  def render("job.json", %{job: job}) do
    %{id: job.id,
      spec: job.spec,
      deployment_id: job.deployment_id}
  end
end

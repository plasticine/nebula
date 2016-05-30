defmodule Orchestrator.DeployTest do
  use Orchestrator.ModelCase

  alias Orchestrator.Deploy
  alias Orchestrator.Project

  @valid_attrs %{
    ref: "master",
    rev: "abc123",
    slug: "some-slug",
    state: "pending"
  }
  @invalid_attrs %{}

  defp make_valid_attrs, do: Map.put(@valid_attrs, :project_id, create_project.id)

  defp create_project do
    {:ok, project} = Project.changeset(%Project{}, %{name: "Test Project", description: "test"}) |> Repo.insert
    project
  end

  test "changeset with valid attributes" do
    changeset = Deploy.changeset(%Deploy{}, make_valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Deploy.changeset(%Deploy{}, @invalid_attrs)
    refute changeset.valid?
  end
end

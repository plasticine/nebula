defmodule Nebula.LogTest do
  use Nebula.ModelCase

  alias Nebula.Log
  alias Nebula.Db.Project

  @valid_attrs %{body: "some content"}
  @invalid_attrs %{}

  defp make_valid_attrs, do: Map.put(@valid_attrs, :project_id, create_project.id)

  defp create_project do
    {:ok, project} = Project.changeset(%Project{}, %{name: "Test Project", description: "test"}) |> Repo.insert
    project
  end

  test "changeset with valid attributes" do
    changeset = Log.changeset(%Log{}, make_valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Log.changeset(%Log{}, @invalid_attrs)
    refute changeset.valid?
  end
end

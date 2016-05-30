defmodule Orchestrator.Project do
  use Orchestrator.Web, :model

  schema "projects" do
    field :name, :string
    field :slug, :string
    field :description, :string

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w(description)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> slugify_name
  end

  defp slugify_name(changeset) do
    if name = get_change(changeset, :name) do
      slug = String.downcase(name) |> String.replace(~r/[^\w-]+/, "-")
      put_change(changeset, :slug, slug)
    else
      changeset
    end
  end

  def push_url(project) do
    Path.join(["https://git.sploosh.cool/", project.slug <> ".git"])
  end
end

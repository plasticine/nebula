defmodule Nebula.Deploy do
  use Nebula.Web, :model

  schema "deployment" do
    belongs_to :project, Nebula.Project
    field :ref, :string
    field :rev, :string
    field :slug, :string
    field :state, :string

    timestamps
  end

  @required_fields ~w(project_id ref rev slug state)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end

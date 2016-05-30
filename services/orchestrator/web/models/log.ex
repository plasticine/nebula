defmodule Orchestrator.Log do
  use Orchestrator.Web, :model

  schema "logs" do
    belongs_to :project, Orchestrator.Project
    field :body, :string

    timestamps
  end

  @required_fields ~w(project_id body)
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

defmodule Nebula.Job do
  use Nebula.Web, :model

  schema "jobs" do
    field :spec, :string
    belongs_to :deploy, Nebula.Deployment

    timestamps
  end

  @required_fields ~w(spec)
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

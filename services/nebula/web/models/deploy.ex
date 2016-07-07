defmodule Nebula.Deploy do
  use Nebula.Web, :model

  defmodule States do
    defstruct accepted: "accepted",
              pending: "pending",
              running: "running",
              dead: "dead"
  end

  schema "deploys" do
    belongs_to :project, Nebula.Project
    has_one :job, Nebula.Job

    field :ref, :string
    field :rev, :string
    field :slug, :string
    field :state, :string
    field :expire_at, Timex.Ecto.DateTime

    timestamps
  end

  @required_fields ~w(project_id ref rev slug state)
  @optional_fields ~w(expire_at)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def states do
    %Nebula.Deploy.States{}
  end
end

defmodule Orchestrator.Repo.Migrations.CreateDeploy do
  use Ecto.Migration

  def up do
    create table(:projects) do
      add :name, :string
      add :slug, :string
      add :description, :string

      timestamps
    end
    create index(:projects, [:name], unique: true)
    create index(:projects, [:slug], unique: true)

    create table(:logs) do
      add :project_id, references(:projects), null: false
      add :body, :text

      timestamps
    end
    create index(:logs, [:project_id])

    create table(:deployment) do
      add :project_id, references(:projects), null: false
      add :ref, :string, null: false
      add :rev, :string, null: false
      add :slug, :string, null: false
      add :state, :string, null: false, default: "pending"

      timestamps
    end
    create index(:deployment, [:project_id])
    create index(:deployment, [:slug], unique: true)
    create index(:deployment, [:ref], unique: false)
    create index(:deployment, [:rev], unique: false)
  end
end

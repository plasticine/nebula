defmodule Nebula.Repo.Migrations.CreateDeploy do
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

    # create table(:logs) do
    #   add :project_id, references(:projects), null: false
    #   add :body, :text

    #   timestamps
    # end
    # create index(:logs, [:project_id])

    create table(:deploys) do
      add :project_id, references(:projects, on_delete: :nothing), null: false
      add :ref, :string, null: false
      add :rev, :string, null: false
      add :slug, :string, null: false
      add :state, :string, null: false, default: "pending"

      timestamps
    end
    create index(:deploys, [:project_id])
    create index(:deploys, [:slug], unique: true)
    create index(:deploys, [:ref], unique: false)
    create index(:deploys, [:rev], unique: false)

    create table(:jobs) do
      add :spec, :text, null: false
      add :deploy_id, references(:deploys, on_delete: :nothing), null: false

      timestamps
    end
    create index(:jobs, [:deploy_id])
  end
end

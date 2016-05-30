ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Orchestrator.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Orchestrator.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Orchestrator.Repo)


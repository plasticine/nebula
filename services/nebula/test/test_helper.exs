ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Nebula.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Nebula.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Nebula.Repo)


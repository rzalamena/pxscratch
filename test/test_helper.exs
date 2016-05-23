ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Pxscratch.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Pxscratch.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Pxscratch.Repo)


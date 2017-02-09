defmodule Migrator.Runner do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(_) do
    GenServer.cast(self(), :migrate)
    {:ok, %{}}
  end

  def handle_cast(:migrate, _) do
    dir = System.get_env("DIRECTORY")
    if dir, do: action(System.get_env("ACTION"), dir), else: show_usage()
    {:stop, :normal, %{}}
  end

  def terminate(_, _) do
    :init.stop()
  end

  defp action("migrate", dir), do: Ecto.Migrator.run(Migrator.Repo, dir, :up, all: true)

  defp action("rollback", dir), do: Ecto.Migrator.run(Migrator.Repo, dir, :down, step: 1)

  defp action(_, _), do: show_usage()

  defp show_usage do
    IO.puts """
      Usage:
      DIRECTORY=/path/to/migrations ACTION=migrate|rollback DB_NAME=name DB_USER=user DB_PASSWORD=password REPLACE_OS_VARS=true bin/migrator foreground
    """
  end
end

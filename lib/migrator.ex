defmodule Migrator do
  @moduledoc """
  Runs migrations on a production host.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Migrator.Repo, [], restart: :temporary),
      worker(Migrator.Runner, [[]], restart: :temporary)
    ]

    opts = [strategy: :one_for_all, name: Migrator.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

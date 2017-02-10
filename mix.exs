defmodule Migrator.Mixfile do
  use Mix.Project

  def project, do: [
    app: :migrator,
    version: "0.1.0",
    elixir: "~> 1.4",
    build_embedded: Mix.env == :prod,
    start_permanent: false,
    deps: deps()
  ]

  def application, do: [
    applications: [:logger, :postgrex, :ecto, :crypto],
    mod: {Migrator, []}
  ]

  defp deps, do: [
    {:postgrex, ">= 0.0.0"},
    {:ecto, "~> 2.1.0"},
    {:distillery, "~> 1.0"}
  ]
end

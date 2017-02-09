use Mix.Config

config :migrator, Migrator.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "autorecall",
  password: "autorecall",
  database: "autorecall_dev",
  hostname: "localhost"

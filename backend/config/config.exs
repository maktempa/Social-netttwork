use Mix.Config

config :backend, Backend.Repo,
  database: "backend_db",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :backend, ecto_repos: [Backend.Repo]

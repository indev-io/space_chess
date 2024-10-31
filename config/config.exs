# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :space_chess,
  ecto_repos: [SpaceChess.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :space_chess, SpaceChessWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: SpaceChessWeb.ErrorHTML, json: SpaceChessWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: SpaceChess.PubSub,
  live_view: [signing_salt: "/lqhpoNl"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.

# DEFAULT SPACECHESS MAILER

config :space_chess, SpaceChess.Mailer, adapter: Swoosh.Adapters.Local

# CONFIGURE FOR PRODUCTION TO ACTUALLY SEND EMAILS
# config :space_chess, SpaceChess.Mailer,
#   adapter: Swoosh.Adapters.Mailgun,
#   api_key: "a0e91d8bdc04850bd6054f166074052c-72e4a3d5-7722f694",
#   domain: "sandbox456fa61e77444f2ebb45760d618bfd8f.mailgun.org"

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  space_chess: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  space_chess: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

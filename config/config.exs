# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :play_it_cool,
  ecto_repos: [PlayItCool.Repo]

config :play_it_cool_web,
  ecto_repos: [PlayItCool.Repo],
  generators: [context_app: :play_it_cool]

# Configures the endpoint
config :play_it_cool_web, PlayItCoolWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "AtoE0MKoREUgnGeTYM6Y0sFCq7R86bCqXLGfhpuurcv6Aof78q8f1Qw/3hZLcVWr",
  render_errors: [view: PlayItCoolWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: PlayItCool.PubSub,
  live_view: [signing_salt: "rTby/YTj"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

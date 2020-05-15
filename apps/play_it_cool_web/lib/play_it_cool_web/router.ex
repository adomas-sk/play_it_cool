defmodule PlayItCoolWeb.Router do
  use PlayItCoolWeb, :router

  # import Absinthe

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :graphql do
    plug PlayItCoolWeb.Context
  end

  scope "/", PlayItCoolWeb do
    pipe_through :browser

    get "/ping", PageController, :ping
    get "/", PageController, :index
  end

  scope "/api" do
    pipe_through :graphql

    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: PlayItCoolWeb.Schema

    forward "/", Absinthe.Plug, schema: PlayItCoolWeb.Schema
  end

  scope "/web", PlayItCoolWeb do
    pipe_through :browser

    get "/*path", PageController, :react
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: PlayItCoolWeb.Telemetry
    end
  end
end

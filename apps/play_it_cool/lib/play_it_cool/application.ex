defmodule PlayItCool.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      PlayItCool.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: PlayItCool.PubSub},
      # Start the Registry
      {Registry, keys: :unique, name: Registry.GameLobbies},
      # Start DynamicSupervisor for GameLobbies
      {DynamicSupervisor, name: GameLobbiesSupervisor, strategy: :one_for_one}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: PlayItCool.Supervisor)
  end
end

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
      {Phoenix.PubSub, name: PlayItCool.PubSub}
      # Start a worker by calling: PlayItCool.Worker.start_link(arg)
      # {PlayItCool.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: PlayItCool.Supervisor)
  end
end

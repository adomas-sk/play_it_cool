defmodule PlayItCool.Repo do
  use Ecto.Repo,
    otp_app: :play_it_cool,
    adapter: Ecto.Adapters.Postgres
end

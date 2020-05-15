# PlayItCool.Umbrella

A game project

## Setup

Prerequisites:

- Elixir (I'm using 1.10.1)
- OTP (I'm using 22)
- docker
- docker-compose

```
  # at root of project
  docker-compose -f docker-compose.dev.yml up -d
  mix setup
```

To populate database for testing

```
  mix apps/play_it_cool/priv/repo/seeds.exs
```

## Running project

```
  # at root of project
  iex -S mix phx.server # of if you don't want iex for debuging: mix phx.server
```

By default project is running on port 4000

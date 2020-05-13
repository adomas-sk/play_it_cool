# PlayItCool.Umbrella

A game project

## Setup

Prerequisites:

- Elixir (I'm using 1.10.1)
- OTP (I'm using 22)
- docker
- docker-compose

```bash
  # at root of project
  mix deps.get
  cd apps/play_it_cool_web/assets
  npm i
```

## Running project

```bash
  docker-compose -f docker-compose.dev.yml up -d
  iex -S mix phx.server # of if you don't want iex for debuging: mix phx.server
```

By default project is running on port 4000

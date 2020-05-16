FROM elixir:1.10.0-alpine AS build

WORKDIR /app

RUN apk add --no-cache build-base npm git python
RUN mix do local.hex --force, local.rebar --force

COPY config/ /app/config/
COPY mix.exs /app/
COPY mix.* /app/

COPY apps/play_it_cool/mix.exs /app/apps/play_it_cool/
COPY apps/play_it_cool_web/mix.exs /app/apps/play_it_cool_web/

ARG DATABASE_URL
ARG SECRET_KEY_BASE
ARG TOKEN_SECRET
ARG PORT

# set build ENV
ENV MIX_ENV=prod
ENV DATABASE_URL $DATABASE_URL
ENV SECRET_KEY_BASE $SECRET_KEY_BASE
ENV TOKEN_SECRET $TOKEN_SECRET
ENV PORT $PORT

RUN mix do deps.get --only ${MIX_ENV}, deps.compile

COPY . /app/

WORKDIR /app/apps/play_it_cool_web
RUN MIX_ENV=prod mix compile
RUN npm ci --prefix ./assets
RUN npm run deploy --prefix ./assets
RUN mix phx.digest

WORKDIR /app
# compile and build release
RUN mix do compile, release
RUN mix ecto.migrate

# prepare release image
FROM alpine:3.11 AS app
RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/play_it_cool ./

ENV HOME=/app

EXPOSE $PORT

CMD ["bin/play_it_cool", "start"]
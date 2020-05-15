defmodule PlayItCoolWeb.PageController do
  use PlayItCoolWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def react(conn, _params) do
    render(conn, "react.html")
  end

  def ping(conn, _params) do
    json(conn, "pong")
  end
end

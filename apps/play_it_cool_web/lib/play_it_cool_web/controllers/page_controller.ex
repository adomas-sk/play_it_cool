defmodule PlayItCoolWeb.PageController do
  use PlayItCoolWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def react(conn, _params) do
    render(conn, "react.html")
  end
end

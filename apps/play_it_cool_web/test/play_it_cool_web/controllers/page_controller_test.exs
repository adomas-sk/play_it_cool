defmodule PlayItCoolWeb.PageControllerTest do
  use PlayItCoolWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Resources"
  end

  test "GET /web", %{conn: conn} do
    conn = get(conn, "/web")
    assert html_response(conn, 200) =~ "<div id=\"app\">"
  end
end

defmodule TaskManagerWeb.PageControllerTest do
  use TaskManagerWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 302) =~ "You are being"
  end
end

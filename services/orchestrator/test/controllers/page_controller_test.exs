defmodule Orchestrator.PageControllerTest do
  use Orchestrator.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Dashboard"
  end
end

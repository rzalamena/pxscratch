defmodule Pxscratch.PageControllerTest do
  use Pxscratch.ConnCase

  alias Pxscratch.Factory

  setup do
    normal_role = Factory.create(:role, %{admin: false})
    normal_user = Factory.create(:user, %{role: normal_role})
    {:ok, normal_user: normal_user}
  end

  test "new session as logged out user", %{normal_user: normal_user} do
    conn = conn()
    conn = get(conn, session_path(conn, :new))
    assert html_response(conn, 200)

    conn = post(conn, session_path(conn, :create), user: %{
      email: normal_user.email,
      password: normal_user.password,
    })
    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "new session as logged in user", %{normal_user: normal_user} do
    conn = conn()
    conn = post(conn, session_path(conn, :create), user: %{
      email: normal_user.email,
      password: normal_user.password,
    })
    assert redirected_to(conn) == page_path(conn, :index)

    conn = get(conn, session_path(conn, :new))
    assert get_flash(conn, :error)
  end

  test "log out user as logged user", %{normal_user: normal_user} do
    conn = conn()
    conn = post(conn, session_path(conn, :create), user: %{
      email: normal_user.email,
      password: normal_user.password,
    })
    assert redirected_to(conn) == page_path(conn, :index)
    assert Plug.Conn.get_session(conn, :current_user)

    conn = delete(conn, session_path(conn, :delete, -1))
    refute Plug.Conn.get_session(conn, :current_user)
  end
end

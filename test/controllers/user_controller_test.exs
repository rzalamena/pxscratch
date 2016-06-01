defmodule Pxscratch.UserControllerTest do
  use Pxscratch.ConnCase

  alias Pxscratch.Factory
  alias Pxscratch.Setting
  alias Pxscratch.User

  setup do
    normal_role = Factory.create(:role, %{admin: false})
    normal_user = Factory.create(:user, %{role: normal_role})
    admin_role = Factory.create(:role, %{admin: true})
    admin_user = Factory.create(:user, %{role: admin_role})
    {
      :ok, normal_user: normal_user, admin_user: admin_user,
      normal_role: normal_role, admin_role: admin_role,
    }
  end

  test "public registration denied", %{normal_role: normal_role} do
    Repo.get_by(Setting, name: "public_sign_in")
    |> Setting.update_changeset(%{bvalue: false})
    |> Repo.update

    conn = conn()
    conn = get(conn, user_path(conn, :new))
    assert html_response(conn, 302)

    user = Factory.build(:user, %{role: normal_role})
    conn = post(conn, user_path(conn, :create), user: %{
      email: user.email,
      nickname: user.nickname,
      password: user.password,
    })
    assert redirected_to(conn) == page_path(conn, :index)
    assert get_flash(conn, :error)
  end

  test "public registration allowed", %{normal_role: normal_role} do
    Repo.get_by(Setting, name: "public_sign_in")
    |> Setting.update_changeset(%{bvalue: true})
    |> Repo.update

    conn = conn()
    conn = get(conn, user_path(conn, :new))
    assert html_response(conn, 200)

    user = Factory.build(:user)
    conn = post(conn, user_path(conn, :create), user: %{
      email: user.email,
      nickname: user.nickname,
      password: user.password,
      password_confirmation: user.password,
      role_id: normal_role.id,
    })
    assert redirected_to(conn) == page_path(conn, :index)
    refute get_flash(conn, :error)

    # We tried to trick user controller to use our role, but it should not
    # happen.
    new_user = Repo.get_by(User, email: user.email)
    assert new_user
    assert new_user.role_id == 1
    assert new_user.role_id != normal_role.id
  end

  test "admin user registration",
    %{admin_user: admin_user, normal_role: normal_role} do
    conn = conn()
    conn = post(conn, session_path(conn, :create), user: %{
      email: admin_user.email,
      password: admin_user.password,
    })
    assert html_response(conn, 302)
    refute get_flash(conn, :error)

    user = Factory.build(:user)
    conn = post(conn, user_path(conn, :create), user: %{
      email: user.email,
      nickname: user.nickname,
      password: user.password,
      password_confirmation: user.password,
      role_id: normal_role.id,
    })
    assert html_response(conn, 302)
    refute get_flash(conn, :error)

    # The controller should apply the desired role the admin selected.
    new_user = Repo.get_by(User, email: user.email)
    assert new_user
    assert new_user.role_id != 1
    assert new_user.role_id == normal_role.id
  end
end

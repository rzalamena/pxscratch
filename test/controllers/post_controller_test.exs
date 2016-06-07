defmodule Pxscratch.PostControllerTest do
  use Pxscratch.ConnCase

  alias Pxscratch.Factory
  alias Pxscratch.Post

  setup do
    poster_role = Factory.create(:role)
    poster_user = Factory.create(:user, %{role: poster_role})
    {:ok, poster_user: poster_user}
  end

  test "Deny guest to post/edit/delete" do
    post = Factory.create(:post)

    conn = conn()

    conn = get(conn, post_path(conn, :new))
    assert html_response(conn, 302)
    assert get_flash(conn, :error)
    conn = clear_flash(conn)

    conn = post(conn, post_path(conn, :create), post: %{})
    assert html_response(conn, 302)
    assert get_flash(conn, :error)
    conn = clear_flash(conn)

    conn = delete(conn, post_path(conn, :delete, post))
    assert html_response(conn, 302)
    assert get_flash(conn, :error)
    conn = clear_flash(conn)
    assert Repo.get(Post, post.id)

    conn = get(conn, post_path(conn, :edit, post))
    assert html_response(conn, 302)
    assert get_flash(conn, :error)
    conn = clear_flash(conn)

    new_title = "update test"
    conn = put(conn, post_path(conn, :update, post), post: %{title: new_title})
    assert html_response(conn, 302)
    assert get_flash(conn, :error)
    post = Repo.get(Post, post.id)
    assert post.title != new_title
  end

  test "Authorize user to post/edit/delete", %{poster_user: poster_user} do
    post = Factory.create(:post, %{user: poster_user})
    conn =
      conn()
      |> login_as(poster_user)

    conn = get(conn, post_path(conn, :new))
    assert html_response(conn, 302)
    refute get_flash(conn, :error)
    conn = clear_flash(conn)

    conn = get(conn, post_path(conn, :edit, post))
    assert html_response(conn, 200)

    new_title = "foo bar title"
    conn = put(conn, post_path(conn, :update, post), post: %{title: new_title})
    assert html_response(conn, 302)
    refute get_flash(conn, :error)

    updated_post = Repo.get(Post, post.id)
    assert updated_post.title == new_title
    assert post.title != updated_post.title

    conn = delete(conn, post_path(conn, :delete, post))
    assert html_response(conn, 302)
    refute get_flash(conn, :error)

    refute Repo.get(Post, post.id)
  end

  test "Anyone can read a published post" do
    past = %Ecto.DateTime{
      year: 2000,
      month: 1,
      day: 1,
      hour: 1,
      min: 1,
      sec: 1,
    }
    post = Factory.create(:post, %{publish_date: past})
    conn = conn()

    conn = get(conn, post_path(conn, :show, post))
    assert html_response(conn, 200)
    refute get_flash(conn, :error)
  end

  test "No one can see unpublished posts" do
    future = %Ecto.DateTime{
      year: 2037,
      month: 12,
      day: 1,
      hour: 20,
      min: 10,
      sec: 10,
    }
    post = Factory.create(:post, %{publish_date: future})
    conn = conn()

    conn = get(conn, post_path(conn, :show, post))
    assert html_response(conn, 302)
    assert get_flash(conn, :error)
  end

  test "Published posts with password" do
    past = %Ecto.DateTime{
      year: 2000,
      month: 1,
      day: 1,
      hour: 1,
      min: 1,
      sec: 1,
    }
    password = "secret password"
    post = Factory.create(:post, %{password: password, publish_date: past})
    conn = conn()

    conn = get(conn, post_path(conn, :show, post))
    assert html_response(conn, 200)
    assert get_flash(conn, :info)
    conn = clear_flash(conn)

    conn = get(conn, post_path(conn, :show, post), "password": password)
    assert html_response(conn, 200)
    refute get_flash(conn, :error)
  end
end

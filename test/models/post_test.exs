defmodule Pxscratch.PostTest do
  use Pxscratch.ModelCase

  alias Pxscratch.Factory
  alias Pxscratch.Post

  setup do
    poster_role = Factory.create(:role)
    poster_user = Factory.create(:user, %{role: poster_role})
    {:ok, poster_user: poster_user}
  end

  test "create new post", %{poster_user: poster_user} do
    changeset = Post.changeset(%Post{}, %{user_id: poster_user.id})
    assert {:ok, _} = Repo.insert(changeset)
  end

  test "set page_url", %{poster_user: poster_user} do
    title = "Foo bar"
    slugified_title = Slugger.slugify_downcase(title)
    changeset = Post.changeset(%Post{}, %{title: title, user_id: poster_user.id})

    changeset_page_url = get_change(changeset, :page_url)
    assert changeset_page_url == slugified_title
  end

  test "set publish date", %{poster_user: poster_user} do
    post = Factory.create(:post, %{user: poster_user, publish_date: nil})

    publish_at = Ecto.DateTime.utc()

    changeset = Post.changeset(post, %{publish_date: publish_at})
    publish_date = get_change(changeset, :publish_date)
    assert is_nil(publish_date)

    changeset = Post.changeset(post, %{publish: false, publish_date: publish_at})
    publish_date = get_change(changeset, :publish_date)
    assert is_nil(publish_date)

    changeset = Post.changeset(post, %{publish: true, publish_date: publish_at})
    publish_date = get_change(changeset, :publish_date)
    assert :eq == Ecto.DateTime.compare(publish_date, publish_at)
  end

  test "set password", %{poster_user: poster_user} do
    post = Factory.create(:post, %{user: poster_user})

    password = "abcdabcd"
    changeset = Post.changeset(post, %{password: password})
    saved_password = get_change(changeset, :password)
    assert is_nil(saved_password)

    changeset = Post.changeset(post, %{protect: false, password: password})
    saved_password = get_change(changeset, :password)
    assert is_nil(saved_password)

    changeset = Post.changeset(post, %{protect: true, password: password})
    saved_password = get_change(changeset, :password)
    assert password == saved_password
  end
end

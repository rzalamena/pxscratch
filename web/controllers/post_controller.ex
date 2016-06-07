defmodule Pxscratch.PostController do
  use Pxscratch.Web, :controller

  alias Pxscratch.Post

  plug :scrub_params, "post" when action in [:create, :update]
  plug :authorize_user when not action in [:show]

  def index(conn, _params) do
    posts = Repo.all(Post)
    posts = Repo.preload(posts, :user)
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    user = conn.assigns[:current_user]
    changeset = Post.changeset(%Post{}, %{user_id: user.id})
    case Repo.insert(changeset) do
      {:ok, post} ->
        conn
        |> redirect(to: post_path(conn, :edit, post))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"post" => post_params}) do
    user = conn.assigns[:current_user]
    changeset = Post.changeset(%Post{}, %{post_params | user_id: user.id})
    case Repo.insert(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: post_path(conn, :edit, post))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp show_int(conn, params) do
    id = params["id"]
    password = params["password"]
    post = Repo.get!(Post, id)
    if Post.is_published(post) do
      if Post.is_authenticated(post, password) do
        render(conn, "show.html", post: post)
      else
        conn
        |> put_flash(:info, "You need password to see this post")
        |> render("show.html", post: post)
      end
    else
      conn
      |> put_flash(:error, "Post is not avaliable")
      |> redirect(to: page_path(conn, :index))
    end
  end

  def show(conn, params = %{}) do
    unless Map.has_key?(params, "id") do
      params = Map.put(params, "id", 0)
    end
    unless Map.has_key?(params, "password") do
      params = Map.put(params, "password", nil)
    end
    show_int(conn, params)
  end

  def edit(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    changeset = Post.new_changeset(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post, post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: post_path(conn, :edit, post))
      {:error, changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end
end

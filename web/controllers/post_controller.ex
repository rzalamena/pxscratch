defmodule Pxscratch.PostController do
  use Pxscratch.Web, :controller

  alias Pxscratch.Post

  plug :scrub_params, "post" when action in [:create, :update]
  plug :authorize_user when not action in [:index, :show]

  def index(conn, params) do
    query = Post
      |> Ecto.Query.order_by([p], desc: p.publish_date)
      |> Ecto.Query.preload(:user)

    query =
      case load_user(conn) do
        {:error, _} -> Ecto.Query.where(query, [p], not is_nil(p.publish_date))
        _ -> query
      end

    page = Pxscratch.Repo.paginate(query, params)
    render(conn, "index.html", posts: page.entries, page: page)
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
    case Integer.parse(id) do
      {number, _} ->
        q = Post
          |> Ecto.Query.where([p], p.id == ^number)
      :error ->
        q = Post
          |> Ecto.Query.where([p], p.page_url == ^id)
    end
    post =
      Repo.one!(q)
      |> Repo.preload(:user)
    if Post.is_published(post) do
      if Post.is_authenticated(post, password) do
        render(conn, "show.html", post: post)
      else
        conn
        |> put_flash(:info, "You need password to see this post")
        |> render("auth.html", post: post, changeset: Post.changeset(%Post{}))
      end
    else
      conn
      |> put_flash(:error, "Post is not avaliable")
      |> redirect(to: page_path(conn, :index))
    end
  end

  def show(conn, params = %{}) do
    if Map.has_key?(params, "post") do
      post_params = params["post"]
      if is_map(post_params) and post_params["password"] do
        params = Map.put(params, "password", post_params["password"])
      end
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

defmodule Pxscratch.Factory do
  use ExMachina.Ecto, repo: Pxscratch.Repo

  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  alias Pxscratch.User
  alias Pxscratch.Post
  alias Pxscratch.Role

  def factory(:user) do
    password = sequence(:password, &"secret #{&1}")
    %User{
      name: sequence(:name, &"name #{&1}"),
      email: sequence(:email, &"email#{&1}@gmail.com"),
      nickname: sequence(:nickname, &"nickname #{&1}"),
      password: password,
      password_digest: hashpwsalt(password),
      role: create(:role)
    }
  end

  def factory(:role) do
    %Role{
      name: sequence(:name, &"name #{&1}"),
      description: sequence(:description, &"Role description #{&1}"),
    }
  end

  def factory(:post) do
    title = sequence(:title, &"Title #{&1}")
    %Post{
      title: title,
      content: "Just some content",
      comment_status: 0,
      page_url: Slugger.slugify_downcase(title),
      publish_date: Ecto.DateTime.utc(),
      user: create(:user),
    }
  end
end

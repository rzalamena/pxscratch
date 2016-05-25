# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Pxscratch.Repo.insert!(%Pxscratch.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Pxscratch.Repo
alias Pxscratch.Role
alias Pxscratch.User

%Role{}
|> Role.changeset(%{
  name: "Default",
  description: "Default user role",
})
|> Repo.insert!


role =
  %Role{}
  |> Role.changeset(%{
    name: "Administrator",
    description: "The website administrator",
    admin: true
  })
  |> Repo.insert!

default_password = "abcdabcd"

%User{}
|> User.changeset(%{
  nickname: "admin",
  email: "admin@admin.com",
  password: default_password,
  password_confirmation: default_password,
  role_id: role.id
})
|> Repo.insert!

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
alias Pxscratch.Setting
alias Pxscratch.User

#
# default roles
#
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


#
# users
#
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


#
# settings
#
%Setting{}
|> Setting.changeset(%{
  name: "website_name",
  description: "Website name",
  type: "text",
  tvalue: "Pxscratch",
})
|> Repo.insert!

%Setting{}
|> Setting.changeset(%{
  name: "public_sign_in",
  description: "Allows anyone to sign in",
  type: "boolean",
  bvalue: false,
})
|> Repo.insert!

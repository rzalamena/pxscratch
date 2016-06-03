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
create_role = fn(role) ->
  old_role = Repo.get_by(Role, name: role.name)
  if old_role do
    old_role
  else
    role
    |> Role.changeset(%{})
    |> Repo.insert!
  end
end

default_role = create_role.(%Role{
  name: "Default",
  description: "Default user role",
})

admin_role = create_role.(%Role{
  name: "Administrator",
  description: "The website administrator",
  admin: true
})


#
# users
#
create_admin = fn(user, role) ->
  default_password = "abcdabcd"
  old_user = Repo.get_by(User, role_id: role.id)
  if old_user do
    old_user
  else
    user
    |> User.changeset(%{role_id: role.id, password: default_password})
    |> Repo.insert!
  end
end

create_admin.(%User{
  nickname: "admin",
  email: "admin@admin.com",
}, admin_role)


#
# settings
#
create_setting = fn(setting) ->
  old_setting = Repo.get_by(Setting, name: setting.name)
  if old_setting do
    old_setting
  else
    setting
    |> Setting.changeset(%{})
    |> Repo.insert!
  end
end

create_setting.(%Setting{
  name: "website_name",
  description: "Website name",
  type: "text",
  tvalue: "Pxscratch",
})

create_setting.(%Setting{
  name: "public_sign_in",
  description: "Allows anyone to sign in",
  type: "boolean",
  bvalue: false,
})

create_setting.(%Setting{
  name: "default_role",
  description: "What is the default role",
  type: "select:role",
  ivalue: default_role.id,
})

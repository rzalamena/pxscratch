defmodule Pxscratch.RoleTest do
  use Pxscratch.ModelCase

  alias Pxscratch.Role
  alias Pxscratch.Factory

  test "create role and update role" do
    changeset = Role.changeset(%Role{}, %{
      name: "foo bar",
      description: nil,
    })
    assert { :ok, role } = Repo.insert(changeset)
    assert role.admin == false

    changeset = Role.changeset(role, %{ admin: true })
    assert { :ok, _ } = Repo.update(changeset)
  end

  test "fail on role with no name" do
    role = Factory.build(:role, %{name: nil})
    changeset = Role.changeset(role)
    assert { :error, _ } = Repo.insert(changeset)
  end
end

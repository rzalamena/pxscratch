defmodule Pxscratch.UserTest do
  use Pxscratch.ModelCase

  import Comeonin.Bcrypt, only: [checkpw: 2]

  alias Pxscratch.User
  alias Pxscratch.Factory

  setup do
    admin_role = Factory.create(:role, %{ admin: true })
    { :ok, admin_role: admin_role }
  end

  test "fill password digest" do
    password = "12345678"
    changeset = User.changeset(%User{}, %{
      name: nil,
      nickname: "foobar",
      email: "foobar@gmail.com",
      password: password,
    })
    digest = get_change(changeset, :password_digest)
    assert checkpw(password, digest)
  end

  test "fail on duplicated email" do
    user = Factory.create(:user)
    duplicated_user = Factory.build(:user, %{email: user.email})
    changeset = User.changeset(duplicated_user)
    assert { :error, _ } = Repo.insert(changeset)
  end

  test "fail on duplicated nickname" do
    user = Factory.create(:user)
    duplicated_user = Factory.build(:user, %{nickname: user.nickname})
    changeset = User.changeset(duplicated_user)
    assert { :error, _ } = Repo.insert(changeset)
  end

  test "accepted emails" do
    user = Factory.create(:user)
    for email <- ~w(aaaaaa@gmail.com foo@bar.ws ba@4c.co bla@arret.br) do
      changeset = User.update_changeset(user, %{email: email})
      assert { :ok, _ } = Repo.update(changeset)
    end
  end

  test "rejected emails" do
    user = Factory.create(:user)
    for email <- ~w(a.com foobar.ws @4c foo@ gmail.br) do
      changeset = User.update_changeset(user, %{email: email})
      assert { :error, _ } = Repo.update(changeset)
    end
  end

  test "user must have an existing role", %{ admin_role: admin_role } do
    user = Factory.build(:user, %{ role_id: nil })
    changeset = User.changeset(user)
    assert { :error, _ } = Repo.insert(changeset)

    changeset = User.changeset(user, %{ role_id: -1 })
    assert { :error, _ } = Repo.insert(changeset)

    changeset = User.changeset(user, %{ role_id: admin_role.id })
    assert { :ok, _ } = Repo.insert(changeset)
  end
end

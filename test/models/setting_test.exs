defmodule Pxscratch.SettingTest do
  use Pxscratch.ModelCase

  alias Pxscratch.Setting

  test "Can't have duplicated name" do
    changeset = Setting.changeset(%Setting{}, %{
      name: "foobar",
      description: "barbaz",
      type: "text"
    })
    assert {:ok, _} = Repo.insert(changeset)
    assert {:error, _} = Repo.insert(changeset)
  end
end

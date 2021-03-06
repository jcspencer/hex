defmodule Mix.Tasks.Hex.KeyTest do
  use HexTest.Case
  @moduletag :integration

  test "list keys" do
    in_tmp fn ->
      Hex.home(System.cwd!)

      user = HexWeb.User.get(username: "user")
      {:ok, key} = HexWeb.API.Key.create("list_keys", user)
      Hex.Util.update_config([key: key.secret])

      Mix.Tasks.Hex.Key.run(["list"])
      assert_received {:mix_shell, :info, ["list_keys"]}
    end
  end

  test "remove key" do
    in_tmp fn ->
      Hex.home(System.cwd!)

      user = HexWeb.User.get(username: "user")
      {:ok, key} = HexWeb.API.Key.create("drop_key", user)
      Hex.Util.update_config([key: key.secret])

      Mix.Tasks.Hex.Key.run(["remove", "drop_key"])

      assert_received {:mix_shell, :info, ["Removing key drop_key..."]}
      refute HexWeb.API.Key.get("drop_key", user)
    end
  end
end

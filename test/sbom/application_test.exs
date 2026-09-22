# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.ApplicationTest do
  use SBoM.FixtureCase, async: false

  # The Burrito standalone path is compiled out unless MIX_ENABLE_BURRITO is
  # set, so this only runs in that build.
  @moduletag :burrito

  @tag :tmp_dir
  @tag fixture_app: "app_library"
  test "standalone application halts instead of returning", %{tmp_dir: tmp_dir, app_path: app_path} do
    script = Path.expand("../fixtures/standalone.exs", __DIR__)
    bom_path = Path.join(tmp_dir, "bom.cdx.json")
    code_paths = Enum.flat_map(:code.get_path(), &["-pa", List.to_string(&1)])

    args =
      code_paths ++
        [
          "-noshell",
          "-eval",
          "application:ensure_all_started(elixir), " <>
            "'Elixir.Code':eval_file(unicode:characters_to_binary(os:getenv(\"SBOM_TEST_SCRIPT\"))).",
          "-extra",
          "cyclonedx",
          "-f",
          "-n",
          "-o",
          bom_path,
          app_path
        ]

    erl = System.find_executable("erl")

    {output, status} =
      System.cmd(erl, args,
        stderr_to_stdout: true,
        env: [{"SBOM_TEST_SCRIPT", script}, {"__BURRITO", nil}]
      )

    # 99 is the fixture's marker for "start/2 returned" - the race this guards.
    refute output =~ "Application startup returned"
    refute status == 99
    assert status == 0, output
    assert File.exists?(bom_path)
  end
end

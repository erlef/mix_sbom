# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2019 Bram Verburg
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule Mix.Tasks.Sbom.CyclonedxTest do
  use SBoM.FixtureCase, async: false
  use SBoM.ValidatorCase, async: false

  import ExUnit.CaptureIO

  alias SBoM.Util

  setup do
    Mix.Shell.Process.flush()

    shell = Mix.shell(Mix.Shell.Process)

    on_exit(fn ->
      Mix.shell(shell)
    end)

    :ok
  end

  @tag :tmp_dir
  @tag fixture_app: "sample1"
  test "mix task", %{app_path: app_path} do
    capture_io(:stderr, fn ->
      capture_io(:stdio, fn ->
        Util.in_project(app_path, fn _mix_module ->
          Mix.Task.rerun("deps.clean", ["--all"])

          bom_path = Path.join(app_path, "bom.cdx")

          Mix.Task.rerun("deps.get")
          Mix.Shell.Process.flush()

          Mix.Task.rerun("sbom.cyclonedx", ["-d", "-f", "-o", bom_path])
          assert_received {:mix_shell, :info, ["* creating bom.cdx"]}

          assert_valid_cyclonedx_bom(bom_path, :protobuf)
        end)
      end)
    end)
  end

  @tag :tmp_dir
  @tag fixture_app: "sample1"
  test "schema validation", %{app_path: app_path} do
    Util.in_project(app_path, fn _mix_module ->
      Mix.Task.rerun("sbom.cyclonedx", ["-d", "-f", "-s", "1.3"])
      assert_received {:mix_shell, :info, ["* creating bom.cdx.json"]}

      assert_raise Mix.Error, "invalid cyclonedx schema version, available versions are 1.7, 1.6, 1.5, 1.4, 1.3", fn ->
        Mix.Task.rerun("sbom.cyclonedx", ["-d", "-f", "-s", "invalid"])
      end
    end)
  end
end

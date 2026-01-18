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
  @tag fixture_app: "app_installed"
  test "mix task", %{app_path: app_path} do
    Util.in_project(app_path, fn _mix_module ->
      capture_io(:stderr, fn ->
        capture_io(:stdio, fn ->
          Mix.Task.rerun("deps.clean", ["--all"])

          bom_path = Path.join(app_path, "bom.cdx")

          Mix.Task.rerun("deps.get")
          Mix.Shell.Process.flush()

          Mix.Task.rerun("sbom.cyclonedx", ["-f", "-o", bom_path])
          assert_received {:mix_shell, :info, ["* creating bom.cdx"]}

          Mix.Task.rerun("sbom.cyclonedx", ["-o", bom_path])
          assert_received {:mix_shell, :info, ["* unchanged bom.cdx"]}

          assert_valid_cyclonedx_bom(bom_path, :protobuf)
        end)
      end)
    end)
  end

  @tag :tmp_dir
  @tag fixture_app: "sample1"
  test "STDOUT output", %{app_path: app_path} do
    out =
      capture_io(:stdio, fn ->
        Util.in_project(app_path, fn _mix_module ->
          Mix.Task.rerun("deps.clean", ["--all"])

          Mix.Task.rerun("deps.get")
          Mix.Shell.Process.flush()

          Mix.Task.rerun("sbom.cyclonedx", ["-o", "-"])
        end)
      end)

    bom_path = Path.join(app_path, "bom.cdx.json")
    File.write!(bom_path, out)
    assert_valid_cyclonedx_bom(bom_path, :json)
  end

  @tag :tmp_dir
  @tag fixture_app: "sample1"
  test "schema validation", %{app_path: app_path} do
    Util.in_project(app_path, fn _mix_module ->
      Mix.Task.rerun("sbom.cyclonedx", ["-f", "-s", "1.3"])
      assert_received {:mix_shell, :info, ["* creating bom.cdx.json"]}

      msg = Regex.escape("invalid value \"invalid\" for --schema(-s) option")

      assert_raise Mix.Error, ~r/#{msg}/, fn ->
        Mix.Task.rerun("sbom.cyclonedx", ["-d", "-f", "-s", "invalid"])
      end
    end)
  end

  @tag :tmp_dir
  @tag fixture_app: "umbrella"
  test "combines umbrella without option", %{app_path: app_path} do
    capture_io(:stderr, fn ->
      capture_io(:stdio, fn ->
        Util.in_project(app_path, fn _mix_module ->
          bom_path = Path.join(app_path, "bom.cdx.json")

          Mix.Task.rerun("sbom.cyclonedx", ["-f", "-o", bom_path])
          assert_received {:mix_shell, :info, ["* creating bom.cdx.json"]}

          assert_valid_cyclonedx_bom(bom_path, :json)
        end)
      end)
    end)
  end

  @tag :tmp_dir
  @tag fixture_app: "umbrella"
  test "writes seaprate files for umbrella with option", %{app_path: app_path} do
    capture_io(:stderr, fn ->
      capture_io(:stdio, fn ->
        Util.in_project(app_path, fn _mix_module ->
          bom_path = Path.join([app_path, "apps", "child_app_name_to_replace", "bom.cdx.json"])

          Mix.Task.rerun("sbom.cyclonedx", ["-f", "-r"])
          assert_received {:mix_shell, :info, ["==> child_app_name_to_replace"]}
          assert_received {:mix_shell, :info, ["* creating bom.cdx.json"]}

          assert_valid_cyclonedx_bom(bom_path, :json)
        end)
      end)
    end)
  end

  describe "filtering with only and targets options" do
    @tag :tmp_dir
    @tag fixture_app: "filterable"
    test "filters dependencies by only option", %{app_path: app_path} do
      Util.in_project(app_path, fn _mix_module ->
        # Test filtering for dev only
        dev_bom_path = Path.join(app_path, "bom_dev.cdx.json")
        Mix.Task.rerun("sbom.cyclonedx", ["-f", "-o", dev_bom_path, "--only", "dev"])
        assert_received {:mix_shell, :info, ["* creating bom_dev.cdx.json"]}

        dev_bom_content = File.read!(dev_bom_path)

        # Should include dev dependencies
        assert String.contains?(dev_bom_content, "ex_doc")
        assert String.contains?(dev_bom_content, "dialyxir")
        assert String.contains?(dev_bom_content, "phoenix_live_dashboard")

        # Should include dependencies available in all envs
        assert String.contains?(dev_bom_content, "jason")

        # Should include multi-env deps that include dev
        assert String.contains?(dev_bom_content, "sweet_xml")
        assert String.contains?(dev_bom_content, "telemetry")

        # Should NOT include test-only dependencies
        refute String.contains?(dev_bom_content, "meck")
        refute String.contains?(dev_bom_content, "excoveralls")

        # Should NOT include prod-only dependencies
        refute String.contains?(dev_bom_content, "hackney")

        # Test filtering for test only
        test_bom_path = Path.join(app_path, "bom_test.cdx.json")
        Mix.Task.rerun("sbom.cyclonedx", ["-f", "-o", test_bom_path, "--only", "test"])
        assert_received {:mix_shell, :info, ["* creating bom_test.cdx.json"]}

        test_bom_content = File.read!(test_bom_path)

        # Should include test dependencies
        assert String.contains?(test_bom_content, "meck")
        assert String.contains?(test_bom_content, "excoveralls")
        assert String.contains?(test_bom_content, "circuits_gpio")

        # Should include dependencies available in all envs
        assert String.contains?(test_bom_content, "jason")

        # Should include multi-env deps that include test
        assert String.contains?(test_bom_content, "sweet_xml")

        # Should NOT include dev-only dependencies
        refute String.contains?(test_bom_content, "ex_doc")
        refute String.contains?(test_bom_content, "dialyxir")

        # Should NOT include prod-only dependencies
        refute String.contains?(test_bom_content, "hackney")
      end)
    end

    @tag :tmp_dir
    @tag fixture_app: "filterable"
    test "filters dependencies by targets option", %{app_path: app_path} do
      Util.in_project(app_path, fn _mix_module ->
        # Test filtering for host target
        host_bom_path = Path.join(app_path, "bom_host.cdx.json")
        Mix.Task.rerun("sbom.cyclonedx", ["-f", "-o", host_bom_path, "--targets", "host"])
        assert_received {:mix_shell, :info, ["* creating bom_host.cdx.json"]}

        host_bom_content = File.read!(host_bom_path)

        # Should include host-targeted dependencies
        assert String.contains?(host_bom_content, "phoenix")
        assert String.contains?(host_bom_content, "phoenix_live_dashboard")

        # Should include dependencies available for all targets
        assert String.contains?(host_bom_content, "jason")
        assert String.contains?(host_bom_content, "ex_doc")

        # Should NOT include rpi-only dependencies
        refute String.contains?(host_bom_content, "nerves")
        refute String.contains?(host_bom_content, "circuits_gpio")

        # Test filtering for rpi target
        rpi_bom_path = Path.join(app_path, "bom_rpi.cdx.json")
        Mix.Task.rerun("sbom.cyclonedx", ["-f", "-o", rpi_bom_path, "--targets", "rpi"])
        assert_received {:mix_shell, :info, ["* creating bom_rpi.cdx.json"]}

        rpi_bom_content = File.read!(rpi_bom_path)

        # Should include rpi-targeted dependencies
        assert String.contains?(rpi_bom_content, "nerves")
        assert String.contains?(rpi_bom_content, "circuits_gpio")

        # Should include dependencies available for all targets
        assert String.contains?(rpi_bom_content, "jason")

        # Should NOT include host-only dependencies
        refute String.contains?(rpi_bom_content, "phoenix")
        refute String.contains?(rpi_bom_content, "phoenix_live_dashboard")
      end)
    end

    @tag :tmp_dir
    @tag fixture_app: "filterable"
    test "filters dependencies by combined only and targets options", %{app_path: app_path} do
      Util.in_project(app_path, fn _mix_module ->
        # Test filtering for dev + host combination
        combined_bom_path = Path.join(app_path, "bom_dev_host.cdx.json")
        Mix.Task.rerun("sbom.cyclonedx", ["-f", "-o", combined_bom_path, "--only", "dev", "--targets", "host"])
        assert_received {:mix_shell, :info, ["* creating bom_dev_host.cdx.json"]}

        combined_bom_content = File.read!(combined_bom_path)

        # Should include dependencies that match both dev AND host
        assert String.contains?(combined_bom_content, "phoenix_live_dashboard")

        # Should include dependencies available in all envs and targets
        assert String.contains?(combined_bom_content, "jason")

        # Should include dev dependencies available for all targets
        assert String.contains?(combined_bom_content, "ex_doc")
        assert String.contains?(combined_bom_content, "dialyxir")

        # Should include host dependencies available for all envs
        assert String.contains?(combined_bom_content, "phoenix")

        # Should NOT include rpi dependencies even if they're dev
        refute String.contains?(combined_bom_content, "circuits_gpio")

        # Should NOT include test dependencies even if they're host
        refute String.contains?(combined_bom_content, "meck")

        # Should NOT include prod-only or rpi-only dependencies
        refute String.contains?(combined_bom_content, "hackney")
        refute String.contains?(combined_bom_content, "nerves")
      end)
    end
  end

  describe "system dependencies filtering" do
    @tag :tmp_dir
    @tag fixture_app: "app_installed"
    test "includes system dependencies by default", %{app_path: app_path} do
      capture_io(:stderr, fn ->
        capture_io(:stdio, fn ->
          Util.in_project(app_path, fn _mix_module ->
            Mix.Task.rerun("deps.clean", ["--all"])
            Mix.Task.rerun("deps.get")
            Mix.Shell.Process.flush()

            bom_path = Path.join(app_path, "bom.cdx.json")
            Mix.Task.rerun("sbom.cyclonedx", ["-f", "-o", bom_path])

            bom_content = File.read!(bom_path)

            # Assert contains system deps
            assert String.contains?(bom_content, "\"elixir\"")
            assert String.contains?(bom_content, "\"stdlib\"")
            assert String.contains?(bom_content, "\"kernel\"")
          end)
        end)
      end)
    end

    @tag :tmp_dir
    @tag fixture_app: "app_installed"
    test "excludes system dependencies with --exclude-system-dependencies", %{app_path: app_path} do
      capture_io(:stderr, fn ->
        capture_io(:stdio, fn ->
          Util.in_project(app_path, fn _mix_module ->
            Mix.Task.rerun("deps.clean", ["--all"])
            Mix.Task.rerun("deps.get")
            Mix.Shell.Process.flush()

            bom_path = Path.join(app_path, "bom.cdx.json")
            Mix.Task.rerun("sbom.cyclonedx", ["-f", "-o", bom_path, "--exclude-system-dependencies"])

            bom_content = File.read!(bom_path)

            # Assert does NOT contain system deps
            refute String.contains?(bom_content, ~s("name":"elixir"))
            refute String.contains?(bom_content, ~s("name":"stdlib"))
            refute String.contains?(bom_content, ~s("name":"kernel"))
            refute String.contains?(bom_content, ~s("name":"logger"))

            # Assert still contains regular hex deps (decimal is in app_installed fixture)
            assert String.contains?(bom_content, "decimal")
          end)
        end)
      end)
    end
  end
end

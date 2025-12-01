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

  @spec json_module_loaded?() :: boolean()
  defp json_module_loaded? do
    Code.ensure_loaded(:json) == {:module, :json}
  end

  @spec json_format_available?() :: boolean()
  defp json_format_available? do
    json_module_loaded?() and function_exported?(:json, :format, 2)
  end

  @spec xml_pretty_available?() :: boolean()
  defp xml_pretty_available? do
    Code.ensure_loaded?(:xmerl_xml_indent)
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

          Mix.Task.rerun("sbom.cyclonedx", ["-f", "-o", bom_path])
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

  describe "pretty JSON encoding (OTP-dependent)" do
    @tag :tmp_dir
    test "behaves correctly on this OTP", %{tmp_dir: tmp_dir} do
      components = Fetcher.fetch()
      bom = CycloneDX.bom(components)

      cond do
        # OTP < 27: :json module not present
        not json_module_loaded?() ->
          assert_raise RuntimeError,
                       ~r/native :json Erlang module is not loaded/,
                       fn ->
                         CycloneDX.encode(bom, :json, true)
                       end

        # OTP >= 27.1: :json.format/2 exists – we expect pretty output
        json_format_available?() ->
          compact = CycloneDX.encode(bom, :json, false)
          pretty = CycloneDX.encode(bom, :json, true)

          # Optionally keep the “valid CycloneDX” check by writing files:
          compact_path = Path.join(tmp_dir, "bom_compact.json")
          pretty_path = Path.join(tmp_dir, "bom_pretty.json")

          File.write!(compact_path, compact)
          File.write!(pretty_path, pretty)

          assert_valid_cyclonedx_bom(compact_path, :json)
          assert_valid_cyclonedx_bom(pretty_path, :json)

          # Pretty should be more readable
          pretty_lines = pretty |> String.split("\n") |> length()
          compact_lines = compact |> String.split("\n") |> length()
          assert pretty_lines > compact_lines

        # OTP 27.0: :json present but format/2 missing – we expect your wrapped error
        true ->
          assert_raise RuntimeError,
                       ~r/:json\.format\/2 is not available/,
                       fn ->
                         CycloneDX.encode(bom, :json, true)
                       end
      end
    end
  end

  describe "pretty XML encoding (OTP-dependent)" do
    @tag :tmp_dir
    test "behaves correctly on this OTP", %{tmp_dir: tmp_dir} do
      components = Fetcher.fetch()
      bom = CycloneDX.bom(components)

      if xml_pretty_available?() do
        # Pretty available: we expect nicer XML
        compact = CycloneDX.encode(bom, :xml, false)
        pretty = CycloneDX.encode(bom, :xml, true)

        # Still validate as CycloneDX
        compact_path = Path.join(tmp_dir, "bom_compact.xml")
        pretty_path = Path.join(tmp_dir, "bom_pretty.xml")

        File.write!(compact_path, compact)
        File.write!(pretty_path, pretty)

        assert_valid_cyclonedx_bom(compact_path, :xml)
        assert_valid_cyclonedx_bom(pretty_path, :xml)

        # Indentation: line breaks + spaces before tags
        assert Regex.match?(~r/\n\s+</, pretty)

        compact_lines = compact |> String.split("\n") |> length()
        pretty_lines = pretty |> String.split("\n") |> length()
        assert pretty_lines >= compact_lines
      else
        # Pretty not available: we expect your helpful RuntimeError
        assert_raise RuntimeError,
                     ~r/Pretty XML formatting is not available/,
                     fn ->
                       CycloneDX.encode(bom, :xml, true)
                     end
      end
    end
  end
end

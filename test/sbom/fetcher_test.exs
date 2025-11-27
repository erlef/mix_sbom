# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.FetcherTest do
  use SBoM.FixtureCase, async: false

  alias SBoM.Fetcher
  alias SBoM.Util

  doctest Fetcher

  describe inspect(&Fetcher.fetch/0) do
    @tag :tmp_dir
    @tag fixture_app: "filterable"
    test "correctly sets only and targets for dependencies", %{app_path: app_path} do
      Util.in_project(app_path, fn _mix_module ->
        deps = Fetcher.fetch()

        # Dependencies with no restrictions (default [:*])
        assert %{only: :*, targets: :*} = deps["jason"]

        # Development only dependencies
        assert %{only: [:dev], targets: :*} = deps["ex_doc"]
        assert %{only: [:dev], targets: :*} = deps["dialyxir"]

        # Test only dependencies
        assert %{only: [:test], targets: :*} = deps["meck"]
        assert %{only: [:test], targets: :*} = deps["excoveralls"]

        # Production only dependencies
        assert %{only: [:prod], targets: :*} = deps["hackney"]

        # Multiple environments
        assert %{only: [:dev, :test], targets: :*} = deps["sweet_xml"]
        assert %{only: [:prod, :dev], targets: :*} = deps["telemetry"]

        # Dependencies with targets
        assert %{only: :*, targets: [:host]} = deps["phoenix"]
        assert %{only: :*, targets: [:rpi]} = deps["nerves"]

        # Dependencies with both only and targets
        assert %{only: [:dev], targets: [:host]} = deps["phoenix_live_dashboard"]
        assert %{only: [:dev, :test], targets: [:rpi]} = deps["circuits_gpio"]

        # Optional dependencies
        # Loaded in Runtime, so not optional in output
        assert %{optional: false, only: :*, targets: :*} = deps["optional_dep"]
        assert %{optional: true, only: [:dev], targets: :*} = deps["optional_dev_dep"]

        # Runtime false dependencies
        assert %{runtime: false, only: [:dev], targets: :*} = deps["mix_test_watch"]

        # Complex combinations
        assert %{
                 optional: true,
                 only: [:dev, :test],
                 targets: [:host, :rpi]
               } = deps["complex_dep"]
      end)
    end
  end
end

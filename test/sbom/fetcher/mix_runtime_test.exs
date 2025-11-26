# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.Fetcher.MixRuntimeTest do
  use SBoM.FixtureCase, async: false

  alias SBoM.Fetcher.MixRuntime
  alias SBoM.Util

  doctest MixRuntime

  describe inspect(&MixRuntime.fetch/1) do
    @tag :tmp_dir
    @tag fixture_app: "app_installed"
    test "generates valid manifest (all levels) for 'app_installed' fixture", %{
      app_path: app_path
    } do
      Util.in_project(app_path, fn _mix_module ->
        assert %{
                 decimal: %{
                   version: "2.3.0",
                   mix_config: [_decimal_one | _decimal_rest],
                   scm: Hex.SCM,
                   dependencies: [],
                   optional: false,
                   runtime: true
                 },
                 number: %{
                   version: "1.0.5",
                   mix_config: [_number_one | _number_rest],
                   scm: Hex.SCM,
                   dependencies: [:decimal],
                   optional: false,
                   runtime: true
                 }
               } = MixRuntime.fetch()
      end)
    end

    @tag :tmp_dir
    @tag fixture_app: "app_locked"
    test "generates valid manifest (first level) for 'app_locked' fixture", %{app_path: app_path} do
      Util.in_project(app_path, fn _mix_module ->
        assert %{
                 expo: %{
                   version: nil,
                   mix_config: [],
                   scm: Mix.SCM.Git,
                   dependencies: [],
                   optional: false,
                   runtime: true
                 },
                 mime: %{
                   version: nil,
                   mix_config: [],
                   scm: Hex.SCM,
                   dependencies: [],
                   optional: false,
                   runtime: true
                 }
               } = MixRuntime.fetch()
      end)
    end

    @tag :tmp_dir
    test "skips manifest for project without mix.exs", %{tmp_dir: tmp_dir} do
      Util.in_project(tmp_dir, fn _mix_module ->
        assert nil == MixRuntime.fetch()
      end)
    end
  end
end

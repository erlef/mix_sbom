# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.Fetcher.MixLockTest do
  use SBoM.FixtureCase, async: false

  import ExUnit.CaptureLog

  alias SBoM.Fetcher.MixLock
  alias SBoM.Util

  doctest MixLock

  describe inspect(&MixLock.fetch/1) do
    @tag :tmp_dir
    @tag fixture_app: "app_locked"
    test "generates valid manifest for 'app_locked' fixture", %{app_path: app_path} do
      Util.in_project(app_path, fn _mix_module ->
        assert %{
                 bunt: %{
                   scm: Hex.SCM,
                   mix_lock: [:hex, :bunt, "0.2.1" | _rest_bunt]
                 },
                 credo: %{
                   scm: Hex.SCM,
                   mix_lock: [:hex, :credo, "1.7.0" | _rest_credo]
                 },
                 expo: %{
                   scm: Mix.SCM.Git,
                   mix_lock: [:git, "https://github.com/elixir-gettext/expo.git" | _rest_expo]
                 },
                 file_system: %{
                   scm: Hex.SCM,
                   mix_lock: [:hex, :file_system, "0.2.10" | _rest_file_system]
                 },
                 jason: %{
                   scm: Hex.SCM,
                   mix_lock: [:hex, :jason, "1.4.0" | _rest_jason]
                 },
                 mime: %{
                   scm: Hex.SCM,
                   mix_lock: [:hex, :mime, "2.0.6" | _rest_mime]
                 }
               } = MixLock.fetch()
      end)
    end

    @tag :tmp_dir
    @tag fixture_app: "app_broken_lock"
    test "generates valid manifest for 'app_broken_lock' fixture", %{app_path: app_path} do
      log =
        capture_log(fn ->
          Util.in_project(app_path, fn _mix_module ->
            assert %{} = MixLock.fetch()
          end)
        end)

      assert log =~ "Failed to read lockfile"
    end

    @tag :tmp_dir
    test "skips manifest for project without mix.exs", %{tmp_dir: tmp_dir} do
      Util.in_project(tmp_dir, fn _mix_module ->
        assert nil == MixLock.fetch()
      end)
    end
  end
end

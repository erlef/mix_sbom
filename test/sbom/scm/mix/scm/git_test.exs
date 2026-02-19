# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.SCM.Mix.SCM.GitTest do
  use SBoM.FixtureCase, async: false

  alias SBoM.SCM.Mix.SCM.Git

  doctest Git

  describe "group/2" do
    test "extracts org from GitHub HTTPS URL via mix_lock" do
      dependency = %{mix_lock: [:git, "https://github.com/elixir-lang/elixir.git", "abc123"]}
      assert Git.group(:elixir, dependency) == "elixir-lang"
    end

    test "extracts org from GitHub SSH URL via mix_lock" do
      dependency = %{mix_lock: [:git, "git@github.com:erlang/otp.git", "abc123"]}
      assert Git.group(:otp, dependency) == "erlang"
    end

    test "extracts org from GitHub URL via mix_dep" do
      dependency = %{mix_dep: {:myapp, nil, [git: "https://github.com/someuser/myapp.git"]}}
      assert Git.group(:myapp, dependency) == "someuser"
    end

    test "returns nil for non-GitHub hosts" do
      dependency = %{mix_lock: [:git, "https://git.example.com/myorg/repo.git", "abc123"]}
      assert Git.group(:repo, dependency) == nil
    end

    test "returns nil when no git info available" do
      assert Git.group(:app, %{}) == nil
    end
  end
end

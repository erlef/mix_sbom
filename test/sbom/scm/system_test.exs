# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.SCM.SystemTest do
  use SBoM.FixtureCase, async: false

  alias SBoM.SCM.SBoM.SCM.System, as: SystemSCM
  alias SBoM.SCM.System

  doctest System

  describe "enhance_metadata/2" do
    test "returns Apache-2.0 and LicenseRef-scancode-unicode licenses for elixir app" do
      metadata = SystemSCM.enhance_metadata(:elixir, %{})

      assert metadata.licenses == ["Apache-2.0", "LicenseRef-scancode-unicode"]
      assert metadata.source_url == "git+https://github.com/elixir-lang/elixir.git#lib/elixir"
      assert metadata.links["github"] == "https://github.com/elixir-lang/elixir"
      assert metadata.links["website"] == "https://elixir-lang.org"
    end

    test "returns only Apache-2.0 license for other elixir apps (mix, logger, etc.)" do
      for app <- [:mix, :logger, :eex, :ex_unit, :iex] do
        metadata = SystemSCM.enhance_metadata(app, %{})

        assert metadata.licenses == ["Apache-2.0"],
               "Expected #{app} to have only Apache-2.0 license"

        assert metadata.source_url == "git+https://github.com/elixir-lang/elixir.git#lib/#{app}"
        assert metadata.links["github"] == "https://github.com/elixir-lang/elixir"
        assert metadata.links["website"] == "https://elixir-lang.org"
      end
    end

    test "returns Apache-2.0 license for erlang apps" do
      for app <- [:kernel, :stdlib, :crypto, :ssl] do
        metadata = SystemSCM.enhance_metadata(app, %{})

        assert metadata.licenses == ["Apache-2.0"],
               "Expected #{app} to have Apache-2.0 license"

        assert metadata.source_url == "git+https://github.com/erlang/otp.git#lib/#{app}"
        assert metadata.links["github"] == "https://github.com/erlang/otp"
        assert metadata.links["website"] == "https://www.erlang.org"
      end
    end

    test "returns Apache-2.0 license for hex app" do
      metadata = SystemSCM.enhance_metadata(:hex, %{})

      assert metadata.licenses == ["Apache-2.0"]
      assert metadata.source_url == "git+https://github.com/hexpm/hex"
      assert metadata.links["github"] == "https://github.com/hexpm/hex"
      assert metadata.links["website"] == "https://hex.pm"
    end

    test "returns empty map for unknown apps" do
      metadata = SystemSCM.enhance_metadata(:unknown_app, %{})

      assert metadata == %{}
    end
  end

  describe "mix_dep_to_purl/2" do
    test "includes download_url and vcs_url in qualifiers for elixir apps" do
      purl = SystemSCM.mix_dep_to_purl({:elixir, nil, []}, "1.15.0")

      assert purl.type == "otp"
      assert purl.name == "elixir"
      assert purl.version == "1.15.0"
      assert purl.qualifiers["repository_url"] == "https://github.com/elixir-lang/elixir"
      assert purl.qualifiers["download_url"] == "https://github.com/elixir-lang/elixir/archive/refs/tags/v1.15.0.zip"
      assert purl.qualifiers["vcs_url"] == "git+https://github.com/elixir-lang/elixir.git"
    end

    test "includes download_url and vcs_url in qualifiers for erlang apps" do
      purl = SystemSCM.mix_dep_to_purl({:kernel, nil, []}, "9.0")

      assert purl.type == "otp"
      assert purl.name == "kernel"
      assert purl.qualifiers["repository_url"] == "https://github.com/erlang/otp"
      assert purl.qualifiers["download_url"] == "https://github.com/erlang/otp/archive/refs/tags/OTP-9.0.zip"
      assert purl.qualifiers["vcs_url"] == "git+https://github.com/erlang/otp.git"
    end

    test "includes download_url and vcs_url in qualifiers for hex app" do
      purl = SystemSCM.mix_dep_to_purl({:hex, nil, []}, "2.0.0")

      assert purl.type == "otp"
      assert purl.name == "hex"
      assert purl.qualifiers["repository_url"] == "https://github.com/hexpm/hex"
      assert purl.qualifiers["download_url"] == "https://github.com/hexpm/hex/archive/refs/tags/v2.0.0.zip"
      assert purl.qualifiers["vcs_url"] == "git+https://github.com/hexpm/hex.git"
    end
  end
end

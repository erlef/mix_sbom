# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

{ pkgs, lib, config, inputs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.system;
    config.allowUnfree = true;
  };
in
{
  packages = with pkgs; [
    git
    sbom-utility
    cyclonedx-cli
    xz
    p7zip
    reuse
    osv-scanner
    scorecard
  ];

  languages.elixir = {
    enable = true;
    # Switch back to normal packages when Erlang 28.1 is available there
    package = pkgs-unstable.beam28Packages.elixir_1_19;
  };

  languages.erlang = {
    enable = true;
    # Switch back to normal packages when Erlang 28.1 is available there
    package = pkgs-unstable.beam28Packages.erlang;
  };

  languages.zig = {
    enable = true;
    package = pkgs-unstable.zig_0_15;
  };

  scripts = {
    protoc-generate = {
      exec = ''
        set -euo pipefail

        PATH="$HOME/.mix/escripts:$PATH"
        mix local.hex --force --if-missing
        mix escript.install hex protobuf 0.15.0 --force
        rm -rf lib/sbom/cyclonedx/v*;
        for PROTO in schemas/cyclonedx/schema/bom-1.*.proto; do
          protoc \
            --elixir_out=one_file_per_module=true:./lib \
            --elixir_opt=package_prefix=SBoM \
            --elixir_opt=include_docs=true \
            "$PROTO"
        done
        mv lib/s_bo_m/cyclonedx/* lib/sbom/cyclonedx/;
        rm -rf lib/s_bo_m;
        find lib/sbom/cyclonedx -path '*/v[0-9]*' -name '*.pb.ex' \
          -exec sed -i 's/SBoM\.Cyclonedx/SBoM.CycloneDX/g' {} +;
        find lib/sbom/cyclonedx -path '*/v[0-9]*' -name '*.pb.ex' \
          -exec sed -i -zE \
            's/(defmodule SBoM\.CycloneDX\.V[0-9]+\.([A-Za-z0-9.]+) do\n)(  [^@])/\1  @moduledoc "CycloneDX \2 model."\n\3/g' \
            {} +;
        mix format
      '';
      packages = with pkgs; [
        pkgs-unstable.beam28Packages.erlang
        pkgs-unstable.beam28Packages.elixir_1_19
        protobuf
        gnused
      ];
    };
  };

  git-hooks.hooks = {
    reuse = {
      enable = true;
      name = "REUSE lint";
      entry = "reuse lint";
      pass_filenames = false;
    };
  };
}

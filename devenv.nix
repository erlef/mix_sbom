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
  ];

  languages.elixir = {
    enable = true;
    # Switch back to normal packages when Erlang 28.1 is available there
    package = pkgs-unstable.beam28Packages.elixir_1_19;
  };

  scripts = {
    protoc-generate = {
      exec = ''
        set -euo pipefail

        PATH="$HOME/.mix/escripts:$PATH"
        mix local.hex --force --if-missing
        mix escript.install hex protobuf 0.15.0 --force
        rm -rf lib/sbom/cyclonedx
        protoc \
          --elixir_out=one_file_per_module=true:./lib \
          --elixir_opt=package_prefix=SBoM \
          schemas/cyclonedx/schema/bom-1.7.proto
        mv lib/s_bo_m/* lib/sbom/
        mix format
      '';
      packages = with pkgs; [
        pkgs-unstable.beam28Packages.erlang
        pkgs-unstable.beam28Packages.elixir_1_19
        protobuf
      ];
    };
  };
}

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
}

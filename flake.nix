{
  description = "A Modern Reimagining of Nomifactory, with new progression and features";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        inherit (nixpkgs) lib;
        pkgs = nixpkgs.legacyPackages.${system};
        tools = builtins.attrValues {inherit (pkgs) jdk21 zip nodejs_24;};
        # TODO: useful development commands implemented as small shell scripts
        # at least a wrapper for juke, if feasible?
        scripts = lib.mapAttrsToList pkgs.writeShellScriptBin {};
      in {
        devShells.default = pkgs.mkShell {packages = tools ++ scripts;};
      }
    );
}

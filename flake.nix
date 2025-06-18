{
  description = "Flake to install tools needed for this repository";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
        pkgs-unstable = import nixpkgs-unstable {
          inherit system;
        };
      in {
        # What is going to be installed when using `nix shell' or `nix profile install`
        packages.default = pkgs.buildEnv {
          name = "default-env";
          paths = [
            pkgs-unstable.direnv

            # This makes `direnv` nix cache faster.
            # Add this to `$HOME/.config/direnv/direnvrc`:
            # `source $HOME/.nix-profile/share/nix-direnv/direnvrc`
            pkgs-unstable.nix-direnv

            pkgs-unstable.git
            pkgs.kubectl
            pkgs.terraform
            pkgs.terraform-docs
            pkgs.kube-linter
            pkgs.yamllint
            pkgs.yamlfix
            pkgs.ansible
            pkgs.just
            pkgs-unstable.fluxcd
            pkgs.kubernetes-helm
            pkgs.yq
            pkgs.jq
            pkgs.d2
            pkgs.kyverno
            pkgs.cmctl
          ];
        };

        # Used in command `nix develop` to enter a development shell.
        # This is also what `direnv` will use to set up the environment.
        devShells.default = pkgs.mkShell {
          buildInputs = [
            self.packages.${system}.default
          ];
        };

        # Used in command `nix fmt` to format files.
        formatter = pkgs.alejandra;
      }
    );
}

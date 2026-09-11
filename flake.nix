{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.systems.url = "github:nix-systems/default";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShellNoCC {
          GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ed25519_sweetdiffusion";

          # Tools that will be made available in your shell
          packages = with pkgs; [
            bashInteractive
            pnpm
            yarn
            bun

            # Useful Next.js development helpers
            typescript
            typescript-language-server
          ];

          # Environment variables set upon entering the shell
          shellHook = ''
            echo "⚡ Next.js development environment loaded!"
            echo "Bun version: $(bun -v)"
            echo "PNPM version: $(pnpm -v)"

            # Ensure local node_modules binaries are accessible in terminal PATH
            # export PATH="$PWD/node_modules/.bin:$PATH"
          '';
        };
      }
    );
}

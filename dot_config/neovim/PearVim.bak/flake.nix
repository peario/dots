{
  description = "Peario's neovim config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    systems.url = "github:nix-systems/default";
  };

  outputs = { self, nixpkgs, systems }: let
    supportedSystems = nixpkgs.lib.genAttrs (import systems);
    forEachSystem = function: supportedSystems (system:
      function nixpkgs.legacyPackages.${system});
  in {
    devShells = forEachSystem (pkgs: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          stylua
          luaPackages.luacheck
          luajitPackages.vusted
          selene
        ];
      };
    });
  };
}

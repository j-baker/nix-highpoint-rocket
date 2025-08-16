{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

    in
    {
      nixosModules.default = ./module.nix;
      formatter.${system} = pkgs.nixfmt-tree;
      checks.${system}.builds = pkgs.linuxPackages.callPackage ./driver.nix { };
    };
}

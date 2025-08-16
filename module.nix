{ config, pkgs, ... }:
let
  driver = config.boot.kernelPackages.callPackage ./driver.nix {};
in {
    boot.extraModulePackages = [ driver ];
    boot.initrd.availableKernelModules = "rr3740a"; 
}

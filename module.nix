{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.hardware.highpoint-3740a;
  driver = config.boot.kernelPackages.callPackage ./driver.nix { };
in
{
  options.hardware.highpoint-3740a = {
    enable = lib.mkEnableOption ''
      Enable the driver for the Highpoint Rocket 3740A
    '';
  };
  config = lib.mkIf cfg.enable {
    boot.extraModulePackages = [ driver ];
    boot.initrd.availableKernelModules = [ "rr3740a" ];
  };
}

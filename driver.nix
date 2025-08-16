{
  lib,
  stdenv,
  fetchzip,
  kernel,
  kernelModuleMakeFlags,
  runCommand,
}:
let

  src = fetchzip {
    url = "https://download.highpoint-tech.com/www/HighPoint-Download/Softwore/Driver/Linux/RocketStor/RR37xx_8xx_28xx_Linux_X86_64_Src_v1.24.4_25_07_09.tar.gz";
    hash = "sha256-O2ijuDaN08MBpflc60m31PFOhUUA9N+VaeuA3uYYmbc=";
    curlOptsList = [
      "-H"
      "User-Agent: different"
    ];
    stripRoot = false;
  };

  extractedSrc = runCommand "extracted-src" { } ''
    mkdir "$out"
    ${src}/rr37xx* --noexec --target "$out"
    cp ${./install.sh} "$out/osm/linux/install.sh"
  '';
in
stdenv.mkDerivation {
  src = extractedSrc;

  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = kernelModuleMakeFlags ++ [
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  postPatch = "cd product/rr3740a/linux";
  name = "rr37xx";
  version = "25.07.09-${kernel.version}";

  installPhase = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/drivers/scsi"
    cp rr3740a.ko "$out/lib/modules/${kernel.modDirVersion}/drivers/scsi/"
  '';

  meta = with lib; {
    description = "driver for highpoint rocket 37xx devices";
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}

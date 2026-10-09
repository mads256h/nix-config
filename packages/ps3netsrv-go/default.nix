{
  lib,
  fetchFromGitHub,
  buildGoModule,
  ...
}:

buildGoModule (finalAttrs: {
  pname = "ps3netsrv-go";
  version = "0.5.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "xakep666";
    repo = "ps3netsrv-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r5cv8Jdr1oBwo0TsXzTF6+kCVCvmOu2B98xzUiloBVY=";
  };

  vendorHash = "sha256-L3x6fnwmVoqXRleiC1P2pVAJYdRvWoGbp3PrqRyWHrw=";

  subPackages = [ "cmd/ps3netsrv-go" ];

  meta = {
    description = "Blah";
    mainProgram = "ps3netsrv-go";
    homepage = "https://github.com/xakep666/ps3netsrv-go";
    changelog = "https://github.com/xakep666/ps3netsrv-go/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})

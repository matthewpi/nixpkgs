{ fetchFromGitHub, buildGoModule, lib, stdenv }:

buildGoModule rec {
  pname = "ory-hydra";
  version = "1.11.8";

  src = fetchFromGitHub {
    owner = "ory";
    repo = "hydra";
    rev = "v${version}";
    sha256 = "sha256-9V+nD7VfzXFijH/r7uP/FKyt/3UCWMJbMY6h8hW7Xm4=";
  };

  vendorSha256 = "sha256-AlTL4HJUogBhz/nTUH+3JKuq5I/nCv/erfoKSpwe/jE=";

  subPackages = [ "." ];

  ldflags = [
    "-s" "-w"
    "-X github.com/ory/hydra/driver/config.Commit=unknown"
    "-X github.com/ory/hydra/driver/config.Date=unknown"
    "-X github.com/ory/hydra/driver/config.Version=v${version}"
  ];

  preBuild = ''
    # patchShebangs doesn't work for this Makefile, do it manually
    substituteInPlace Makefile --replace '/bin/bash' '${stdenv.shell}'
  '';

  meta = with lib; {
    description = "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider optimized for low-latency, high throughput, and low resource consumption";
    homepage = "https://www.ory.sh/hydra/";
    changelog = "https://github.com/${src.owner}/${src.repo}/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthewpi ];
  };
}

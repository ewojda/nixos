{ buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "picofeed";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "seenaburns";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-dqoxD85zSo+ei9ysVgCLhVlNrxyRF2FFOF3xErnCItY=";
  };

	vendorSha256 = "sha256-YDN8Y0xwcVO0iI0KnWNzrmWBKLjsYXurBX7eabrALgo=";

  ldflags = [ "-s" "-w" ];
}

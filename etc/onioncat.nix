{ stdenv, fetchFromGitHub, automake, autoconf }:
stdenv.mkDerivation rec {
  pname = "onioncat";
  version = "0.4.7";
  src = fetchFromGitHub {
    owner = "rahra";
    repo = "onioncat";
    rev = "v${version}";
    sha256 = "sha256-7Z3TxuODLQxKAhEk/ji2Obmz60akhJFC2Es/zusz/gk=";
  };
	preConfigurePhases = [ "preConfigurePhase" ];
	preConfigurePhase = "./autogen.sh";
  buildInputs = [ automake autoconf ];
}

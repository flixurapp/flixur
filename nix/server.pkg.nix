{ buildGoWorkspace, go-bin }:
let
  gopkg = go-bin.fromGoMod ../server/go.mod;
in
buildGoWorkspace {
  go = gopkg;
  pname = "flixur-server";
  version = "0.0.0";
  src = ../.;
  subPackages = [ "server" ];
  modules = ../govendor.toml;
  postInstall = "mv $out/bin/flixur $out/bin/flixur-server";
}

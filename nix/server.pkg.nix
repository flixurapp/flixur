{
  buildGoWorkspace,
  go-bin,
  makeWrapper,

  # path to the frontend files to embed in the server
  frontendDir,
  # extra environment variables to set on the built server binary
  extraEnv ? { },
}:
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

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    mv $out/bin/flixur $out/bin/flixur-server
    wrapProgram $out/bin/flixur-server \
      ${lib.concatStringsSep " " (
        lib.mapAttrsToList (name: value: "--set ${name} ${lib.escapeShellArg value}") (
          # pass the dir to serve the frontend from
          {
            FLIXUR_FRONTEND_DIR = frontendDir;
          }
          // extraEnv
        )
      )}
  '';
}

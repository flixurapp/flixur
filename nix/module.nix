# NixOS module for the Flixur server.
{
  flake,
  ...
}:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.flixur;

  pluginSubmodule = lib.types.submodule {
    options = {
      package = lib.mkOption {
        type = lib.types.package;
        description = "The plugin package.";
      };
      #TODO: implement this somewhere
      options = lib.mkOption {
        type = lib.types.json;
        default = { };
        description = "Free-form plugin configuration that will be passed to the plugin as JSON.";
      };
    };
  };

  # a plugin entry is either a package or the pluginSubmodule
  pluginType = lib.types.coercedTo lib.types.package (p: {
    package = p;
    options = { };
  }) pluginSubmodule;

  pluginName = p: p.package.pname or (throw "flixur plugin ${toString p.package} must set pname");

  # plugin dir aggregates all plugin bins
  pluginDir = pkgs.linkFarm "flixur-plugins" (
    map (
      p:
      let
        name = pluginName p;
      in
      {
        inherit name;
        path = "${p.package}/bin/${p.package.meta.mainProgram or name}";
      }
    ) cfg.plugins
  );

  server =
    let
      frontendDir = if cfg.serveWebsite then flake.packages.${pkgs.system}.flixur-flutter-web else "";
    in
    cfg.package.override {
      inherit frontendDir;
    };
in
{
  options.services.flixur = {
    enable = lib.mkEnableOption "Flixur media server";

    package = lib.mkOption {
      type = lib.types.package;
      default = flake.packages.${pkgs.system}.flixur-server;
      defaultText = lib.literalExpression "flake.packages.<system>.flixur-server";
      description = "The flixur-server package to run.";
    };

    serveWebsite = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to serve the bundled web frontend. When enabled, the flake's
        Flutter web build is served; when disabled, `FLIXUR_FRONTEND_DIR` is
        unset and only the API is exposed.
      '';
    };

    plugins = lib.mkOption {
      type = lib.types.listOf pluginType;
      default = [ ];
      description = ''
        Flixur plugins to enable. Each entry is either a plugin package or an
        attrset of `{ package; options; }`.
      '';
    };

    address = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "Address for the server to listen on.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8787;
      description = "Port for the server to listen on.";
    };

    openFirewall = lib.mkEnableOption "opening the server port in the firewall";
  };

  config = lib.mkIf cfg.enable {
    systemd.services.flixur = {
      description = "Flixur media server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment = {
        FLIXUR_ADDRESS = cfg.address;
        FLIXUR_PORT = toString cfg.port;
        FLIXUR_PLUGIN_DIR = pluginDir;
      };

      serviceConfig = {
        ExecStart = lib.getExe server;
        DynamicUser = true;
        StateDirectory = "flixur";
        WorkingDirectory = "/var/lib/flixur";
        Restart = "on-failure";
        RestartSec = 5;

        # hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        ProtectClock = true;
        ProtectHostname = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictSUIDSGID = true;
        LockPersonality = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };
}

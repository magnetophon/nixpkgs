{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.ringboard;
in
{

  options.services.ringboard = {
    enable = lib.mkEnableOption "Ringboard clipboard manager";

    package = lib.mkPackageOption pkgs "ringboard" { };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.ringboard-server = {
      description = "Ringboard server";
      documentation = [ "https://github.com/SUPERCILEX/clipboard-history" ];
      after = [ "multi-user.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "notify";
        Environment = "RUST_LOG=trace";
        ExecStart = "${cfg.package}/bin/ringboard-server";
        Restart = "on-failure";
        Slice = "ringboard.slice";
      };
    };

    systemd.user.services.ringboard-listener = {
      description = "Ringboard clipboard listener (auto: X11/Wayland)";
      documentation = [ "https://github.com/SUPERCILEX/clipboard-history" ];
      requires = [ "ringboard-server.service" ];
      after = [
        "ringboard-server.service"
        "graphical-session.target"
      ];
      bindsTo = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "exec";
        Environment = "RUST_LOG=trace";
        ExecStart = "${pkgs.writeShellScript "ringboard-listener-auto" ''
          if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
            exec ${cfg.package}/bin/ringboard-wayland
          else
            exec ${cfg.package}/bin/ringboard-x11
          fi
        ''}";
        Restart = "on-failure";
        Slice = "ringboard.slice";
      };
    };

    systemd.user.slices.ringboard = {
      description = "Ringboard clipboard services";
    };

    environment.systemPackages = [ cfg.package ];
  };
}

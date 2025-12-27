{ config, pkgs, ... }:
let
in
{
  # Enable the OpenSSH daemon.
  imports = [
    ./services/caddy.nix
  ];
  services = {
    openssh.enable = true;
    redis.servers.homarr.enable = true;
#     acme-dns = {
#       enable = true;
#       settings = {
#         
#       };
#     };
#     nginx = {
#       enable = true;
#       virtualHosts = {
#         "hetzner007.gdvoisins.com" = {
#           forceSSL = true;
#           enableACME = true;
#         };
#       };
#     };
  };
}
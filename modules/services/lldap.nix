{pkgs, ...}: let
in {
  systemd.tmpfiles.rules = [
    "d /etc/lldap 0775 lldap services"
    "f /etc/lldap/lldap.env 0664 lldap services"
    "f /etc/lldap/.lldap_user_pass 0664 lldap services"
  ];
  services.lldap = {
    enable = true;
    environmentFile = "/etc/lldap/lldap.env";
    package = pkgs.lldap;
    silenceForceUserPassResetWarning = false;
    environment = {}; # PREFIX LLDAP_ take precedence
    settings = {
      http_port = 17170;
      http_host = "::";
      http_url = "http://localhost";
      ldap_port = 3890;
      ldap_host = "::";
      ldap_base_dn = "dc=whowhatetc,dc=com";
      force_ldap_user_pass_reset = false;
      database_url = "sqlite://./users.db?mode=rwc"; # Exemple "postgres://postgres-user:password@postgres-server/my-database"
      ldap_user_pass_file = "/etc/lldap/.lldap_user_pass";
      ldap_user_pass = null;
      ldap_user_email = "admin@lesgrandsvoisins.com";
      ldap_user_dn = "admin";
      jwt_secret_file = null;
    };
  };
}

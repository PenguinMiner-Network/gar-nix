{
  services.openssh = {
    enable = true;
    openFirewall = true;
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
    ports = [
      6969
    ];
    settings = {
      PermitRootLogin = false;
      PasswordAuthentication = false;
    };
  };
}

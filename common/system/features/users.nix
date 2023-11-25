{
  inputs,
  pkgs,
  config,
  ...
}: {
  sops.secrets."users/dominik".neededForUsers = true;

  users = {
    mutableUsers = false;
    users = {
      root.hashedPassword = "!";
      dominik = {
        isNormalUser = true;
        shell = pkgs.nushell;
        hashedPasswordFile = config.sops.secrets."users/dominik".path;
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+atdmf2sps964aPXOvw0BgYl/dgOrxei1SH03ec3UkGnqmFSMhg0WBr+rnuWdfPMeXaZUUZTCJK3CLwhx99nUD36rN5QPuofLvkV1WHhZfW/mH+gpbyHSubkNxzVnu9oGHEmvpREGQIwX/2eqNO9oREZIjsad1raH+zEHRTvJi9CuEJM3Li9P0JFJ3l241BFGgcfS2BamlMfBA4tJoDJ46v1n5Z5OCxj2rOFPtCqFxClNhs2a/9GjUUSxdQsv5kb4Aq/RzdoyYGTYWpm3s6nuGCd/VYV+LwPcXkch4y9UZcVdgyui4t1dk2uXOlXew5Mcmq7PDGdjo3wTjvSTmc2rZ/haIP/r/liwHbsBEpP9mMGJDp4aU5Rehxv97lH+0lYYg7cbNjCP/hitF/Ies0JsZpOjuGMEAFi8b9VvvtkyT2XEHwX+gPvREGiCxWSXx5WHfFraTSbvFGWYmcDijEnn6aQckIjTatrVYOEaxhalb0HP+uM7yshsenrI2ZRNkik= dominik@linpc"
        ];
        extraGroups = ["wheel"];
      };
    };
  };
}

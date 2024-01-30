{

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations.installer = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./installation-cd.nix
      ];
    };
    packages.x86_64-linux.default = self.nixosConfigurations.installer.config.system.build.isoImage;
  };

}

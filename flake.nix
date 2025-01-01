{
  description = "Authenticator python package";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils}:
  flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};

      authenticator = (pkgs.python3.pkgs.buildPythonPackage rec {
        pname = "authenticator";
        version = "1.1.3";
        src = pkgs.python3.pkgs.fetchPypi {
          inherit pname version;
          sha256 = "30b7a84a6983fd9f4b7f91df835ae853e901d301a33a38958f69d9da3c0eba33";
        };
        propagatedBuildInputs = with pkgs.python3.pkgs; [ cryptography iso8601 ];
        doCheck = false;
      });
      mypython = pkgs.python3.withPackages (ps: [ authenticator ]);
    in
    {
      packages.authenticator = authenticator;
      packages.default = self.packages.${system}.authenticator;
    }
  );
}

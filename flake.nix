{
  description = "Pytorch with cuda";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable"; };
  outputs = { self, nixpkgs }:

    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in {
      devShells."x86_64-linux".default = pkgs.mkShell {

        LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
          pkgs.stdenv.cc.cc
          pkgs.zlib
          pkgs.libGL
          pkgs.glib
          "/run/opengl-driver"
        ];

        venvDir = ".venv";
        packages = with pkgs; [
          python312
          python312Packages.venvShellHook
          python312Packages.pip
          python312Packages.icecream
          uv
          figlet
          python312Packages.python-dotenv
        ];

        shellHook = ''
          		figlet Transcript env 

              if [ ! -d ".venv" ]; then
                uv venv .venv
              fi

          		source .venv/bin/activate
          		
              # alias pip="uv pip"
              
              uv pip install -r requirements.txt

              if [ -f .env ]; then
                export $(grep -v '^#' .env | xargs)
              else
                echo ".env file not found!"
              fi

              figlet Transcript started


        '';
      };
    };
}

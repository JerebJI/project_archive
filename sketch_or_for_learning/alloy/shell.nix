{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  buildInputs = [
  ];
  packages = [
    alloy6
  ];
}

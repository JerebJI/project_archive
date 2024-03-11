{ pkgs ? import <nixpkgs> {} }:
let
  my-python-packages = ps: with ps; [
    pandas
    numpy
    opencv4
    matplotlib
    tkinter
    graphviz
    pillow
  ];
in pkgs.mkShell {
  packages = [
    pkgs.graphviz
    (pkgs.python3.withPackages my-python-packages)
  ];
}

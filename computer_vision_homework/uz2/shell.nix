{ pkgs ? import <nixpkgs> {} }:

with pkgs;
let pack = ps: with ps; [
      pandas
      numpy
      tkinter
      matplotlib
      opencv4
    ];
    pyth = pkgs.python3.withPackages pack;
      in pyth.env

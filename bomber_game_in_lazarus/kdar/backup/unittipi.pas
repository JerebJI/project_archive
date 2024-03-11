unit UnitTipi;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TPolje=(Prazno=1,Blok,UniBlok,Obl,Ru,Rd,Ze,Mo,Be,Past,SenzBom,VelBom);//?O Ru3
type
  TStanje=(Duh=1,Coold,Odb,Mrtev,Ujet,Deton,Mav);
type
  TTipka=(U=1,D,L,R,A);
type
  TDog=(Upoc=1,Diam,Ekspl,Cool,Pas,Duhd,Odbd,Mavd);

type TIgralec = record
  diam: TPolje;
  x,y: Integer;
  dx,dy: Integer;
  moc,ziv: Integer;
  deton,scit: Boolean;
  pt: TTipka;
  stanja: array[Low(TStanje)..High(TStanje)] of Boolean;
end;

type TDogodek = record
  dog: TDog;
  x,y: Integer;
  cas: Integer;
  igr: Integer;
end;

implementation

end.


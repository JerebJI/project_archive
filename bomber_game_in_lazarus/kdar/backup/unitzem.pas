unit UnitZem;

{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils, UnitTipi;
var zem: array[1..4,1..21,1..21] of TPolje = ((
(Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok)
),(
(Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok)
),(
(Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok),
(Blok, Prazno, Prazno, Prazno, UniBlok, Prazno, Prazno, Prazno, Prazno, UniBlok, Rd, UniBlok, Prazno, Prazno, Prazno, Prazno, UniBlok, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Rd, Prazno, Blok, Blok, Blok, Blok, Blok, Blok, Prazno, Blok, Blok, Blok, Blok, Blok, Blok, Prazno, Rd, Prazno, Blok),
(Blok, Prazno, Prazno, Rd, Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok, Rd, Prazno, Prazno, Blok),
(Blok, UniBlok, Blok, Blok, Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok, Blok, Blok, UniBlok, Blok),
(Blok, Prazno, Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok, Prazno, Blok),
(Blok, Prazno, Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok, Prazno, Blok),
(Blok, Prazno, Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok, Prazno, Blok),
(Blok, Prazno, Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok, Prazno, Blok),
(Blok, UniBlok, Blok, Prazno, Prazno, Prazno, Prazno, Be, Be, Be, Prazno,Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok, UniBlok, Blok),
(Blok, Rd, Prazno, Prazno, Prazno, Prazno,Prazno, Be, Be, Be, Prazno,Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Rd, Blok),
(Blok, UniBlok, Blok, Prazno, Prazno, Prazno, Prazno, Be, Be, Be, Prazno,Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok, UniBlok, Blok),
(Blok, Prazno, Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok, Prazno, Blok),
(Blok, Prazno, Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok, Prazno, Blok),
(Blok, Prazno, Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok, Prazno, Blok),
(Blok, Prazno, Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok, Prazno, Blok),
(Blok, UniBlok, Blok, Blok, Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok, Blok, Blok, UniBlok, Blok),
(Blok, Prazno, Prazno, Rd, Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok, Rd, Prazno, Prazno, Blok),
(Blok, Prazno, Rd, Prazno, Blok, Blok, Blok, Blok, Blok, Blok, Prazno, Blok, Blok, Blok, Blok, Blok, Blok, Prazno, Rd, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, UniBlok, Prazno, Prazno, Prazno, Prazno, UniBlok, Rd, UniBlok, Prazno, Prazno, Prazno, Prazno, UniBlok, Prazno, Prazno, Prazno, Blok),
(Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok)
),(
(Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Blok, Blok, Prazno, Blok, Blok, Blok, Prazno, Blok, Blok, Blok, Prazno, Blok, Blok, Blok, Prazno, Blok, Blok, Prazno, Blok),
(Blok, Prazno, Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Blok, Blok, Prazno, Blok, Blok, Blok, Prazno, Blok, Blok, Blok, Prazno, Blok, Blok, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Blok, Prazno, Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok, Prazno, Blok, Prazno, Blok),
(Blok, Prazno, Blok, Prazno, Prazno, Prazno, Blok, Blok, Prazno, Blok, Blok, Blok, Prazno, Blok, Blok, Prazno, Prazno, Prazno, Blok, Prazno, Blok),
(Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Blok, Prazno, Prazno, Prazno, Blok, Blok, Prazno, Blok, Blok, Prazno, Prazno, Prazno, Blok, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Prazno, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok),
(Blok, Prazno, Blok, Prazno, Prazno, Prazno, Blok, Prazno, Prazno, Prazno, Blok, Prazno, Prazno, Prazno, Blok, Prazno, Prazno, Prazno, Blok, Prazno, Blok),
(Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Prazno, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Blok, Prazno, Prazno, Prazno, Blok, Blok, Prazno, Blok, Blok, Prazno, Prazno, Prazno, Blok, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok, Prazno, Blok, Prazno, Blok, Prazno, Blok),
(Blok, Prazno, Blok, Prazno, Prazno, Prazno, Blok, Blok, Prazno, Blok, Blok, Blok, Prazno, Blok, Blok, Prazno, Prazno, Prazno, Blok, Prazno, Blok),
(Blok, Prazno, Blok, Prazno, Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok, Prazno, Blok, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Blok, Blok, Prazno, Blok, Blok, Blok, Prazno, Blok, Blok, Blok, Prazno, Blok, Blok, Prazno, Prazno, Prazno, Blok),
(Blok, Prazno, Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok, Prazno, Blok),
(Blok, Prazno, Blok, Blok, Prazno, Blok, Blok, Blok, Prazno, Blok, Blok, Blok, Prazno, Blok, Blok, Blok, Prazno, Blok, Blok, Prazno, Blok),
(Blok, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Prazno, Blok),
(Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok, Blok)
));


implementation



end.


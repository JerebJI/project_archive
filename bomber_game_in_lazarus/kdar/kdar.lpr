program kdar;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, UnitMenu, UnitIgra, UnitTipi, UnitZem, Zmaga
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Title:='Spopad banañ';
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TFormMenu, FormMenu);
  Application.CreateForm(TFormIgra, FormIgra);
  Application.CreateForm(TFormZmaga, FormZmaga);
  Application.Run;
end.


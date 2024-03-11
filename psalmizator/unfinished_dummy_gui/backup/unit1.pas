unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Process;

type

  { TForm1 }

  TForm1 = class(TForm)
    zlogi: TButton;
    sprozi: TButton;
    tonNacin: TEdit;
    tekst: TMemo;
    izhod: TMemo;
    procedure sproziClick(Sender: TObject);
    procedure tekstChange(Sender: TObject);
    procedure zlogiClick(Sender: TObject);
  private

  public

  end;

const prog='/home/jani/Downloads/scryer-prolog/target/release/scryer-prolog';

var
  Form1: TForm1;
  s: ansiString;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.tekstChange(Sender: TObject);
begin
end;

procedure TForm1.sproziClick(Sender: TObject);
begin
  if RunCommand(prog,['/home/jani/Documents/prolog/psalm.pl','-f','-g','izhod("'+tekst.Lines.Text+',o'+tonNacin.Text+'")).'],s) then
     izhod.Lines.Text:=s;
end;

procedure TForm1.zlogiClick(Sender: TObject);
begin
  if RunCommand(prog,['/home/jani/Documents/prolog/psalm.pl','-f','-g','ugibajZloge("'+tekst.Lines.Text+'").'],s) then
     tekst.Lines.Text:=s;
end;

end.


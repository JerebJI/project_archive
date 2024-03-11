unit UnitMenu;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  ExtCtrls, Buttons, UnitIgra, MMSystem, Windows;

type

  { TFormMenu }

  TFormMenu = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ComboBox1: TComboBox;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Timer1: TTimer;
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Timer1StartTimer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  FormMenu: TFormMenu;
  pv: Integer = 0;
  gla: Boolean = True;

implementation

{$R *.lfm}

{ TFormMenu }

procedure TFormMenu.FormShow(Sender: TObject);
begin
  Timer1.Enabled:=True;
end;

procedure TFormMenu.Image1Click(Sender: TObject);
begin
  gla:=not gla;
  if gla then
    begin
      Image1.Picture.LoadFromFile('slike\n.png');
      Timer1.Enabled:=True;
    end
  else
    begin
      Image1.Picture.LoadFromFile('slike\pn.png');
      mciSendString(PChar('close glasba'),nil,0,0);
      Timer1.Enabled:=False;
    end;
end;

procedure TFormMenu.Timer1StartTimer(Sender: TObject);
begin
  mciSendString(PChar('open "glasba\bang.wav" type waveaudio alias glasba'),nil,0,0);
  mciSendString(PChar('play glasba'), nil, 0, 0);
end;

procedure TFormMenu.Timer1Timer(Sender: TObject);
begin
  mciSendString(PChar('close glasba'),nil,0,0);
  mciSendString(PChar('open "glasba\bang.wav" type waveaudio alias glasba'),nil,0,0);
  mciSendString(PChar('play glasba'), nil, 0, 0);
end;

procedure TFormMenu.Button1Click(Sender: TObject);
begin
  UnitIgra.StZem:=ComboBox1.ItemIndex;
  FormIgra.Show;
end;

procedure TFormMenu.Button2Click(Sender: TObject);
begin
  UnitIgra.stig:=UnitIgra.stig+1;
  if UnitIgra.stig=5 then
    UnitIgra.stig:=2;
  Button2.Caption:=inttostr(UnitIgra.stig);
end;

procedure TFormMenu.BitBtn1Click(Sender: TObject);
begin

end;


end.


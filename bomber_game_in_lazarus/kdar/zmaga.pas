unit Zmaga;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TFormZmaga }

  TFormZmaga = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Label1: TLabel;
  private

  public

  end;

var
  FormZmaga: TFormZmaga;

procedure Zmaga(i: Integer);

implementation
{$R *.lfm}

procedure Zmaga(i: Integer);
begin
  FormZmaga.Image2.Picture.LoadFromFile('slike\bano'+inttostr(i)+'.png');
  FormZmaga.Image1.Picture.LoadFromFile('slike\zban'+inttostr(i)+'.png');
  FormZmaga.show();
end;

end.


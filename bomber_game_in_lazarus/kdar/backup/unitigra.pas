unit UnitIgra;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, LCLType,
  LCLIntf, StdCtrls, Math, UnitTipi, UnitZem, MMSystem, Windows, Zmaga;

type

  { TFormIgra }

  TFormIgra = class(TForm)
    TimerTipke: TTimer;
    TimerIgra: TTimer;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerIgraTimer(Sender: TObject);
    procedure TimerTipkeTimer(Sender: TObject);
  private

  public

  end;

const
  vel=21;
  velb=30;
  size=vel*velb;
  z=15;
  p=5;
  zam=size div 4;
  mstig=4;
  vd=10*vel*vel;
  di: array[1..5] of TPolje = (Ru,Rd,Ze,Mo,Be);
  DatPolja: array[Low(TPolje)..High(TPolje)] of string =
    ('tla','nubl','ubl','eks','yb','rb','zb','mb','bb','ol','tla','tla');
  DatDiam: array[Ru..Be] of string = ('by','br','bz','bm','nic');
  DatObr: array[1..mstig] of string = ('zban','zban1','zban','zban');
  Smeri: array[Low(TTipka)..High(TTipka)] of string = ('n','l','','d','');
  Bar: array[Ru..Mo] of string = ('y','r','z','m');
  xi: array[1..4] of Integer = (2,2,vel-1,vel-1);
  yi: array[1..4] of Integer = (2,vel-1,2,vel-1);
  Tipke: array[1..mstig,Low(TTipka)..High(TTipka)] of Word =
    ((VK_UP,VK_LEFT,VK_DOWN,VK_RIGHT,VK_SPACE),(VK_W,VK_A,VK_S,VK_D,VK_Q),(VK_U,VK_H,VK_J,VK_K,VK_Z),(VK_8,VK_4,VK_5,VK_6,VK_7));
  hitx: array[Low(TTipka)..R] of Integer = (0,-1,0,1);
  hity: array[Low(TTipka)..R] of Integer = (-1,0,1,0);

var
  FormIgra: TFormIgra;
  StZem: Integer = 1;
  Polje: array[1..vel,1..vel] of TPolje;
  ImPolje: array[1..vel,1..vel] of TImage;
  Igralci: array[1..mstig] of TIgralec;
  ImIgralci,ImSrca,ImMoci,ImDiam,ImObrazi,ImKaz,ImKazOzad: array[1..mstig] of TImage;
  MenuOzadje: TImage;
  Ozadje: array[1..vel-1,1..vel-1] of TImage;
  Dogodki: array[1..vd] of TDogodek;
  dx: array[1..mstig] of Integer = (0,0,0,0);
  dy: array[1..mstig] of Integer = (0,0,0,0);
  IgrVelBom,IgrSenzBom: array[1..vel,1..vel] of Integer;
  nal: Integer = 0;
  sou: Integer = 0;
  stig: Integer = 4;

implementation

{$R *.lfm}

procedure DodajDogodek(casd,igrd: Integer; dogd: TDog; xd,yd: Integer);
var i: Integer;
begin
  i:=1;
  While (i<vd) and (Dogodki[i].cas>=0) do
    i:=i+1;
  With Dogodki[i] do
  begin
    dog:=dogd;
    igr:=igrd;
    x:=xd;
    y:=yd;
    cas:=casd;
  end;
end;

function PoisciDogodek(x,y: Integer;dog: TDog) :Integer;
var i: Integer;
begin  
  Result:=-1
  for i:=1 to vd do
    if (Dogodki[i].x=x)and(Dogodki[i].y=y)and(Dogodki[i].dog=dog) then
      begin
        Result:=i;
        break;
      end;
end;

function NajdiDogodek(igr: Integer;dog: TDog) :Integer;
var i: Integer;
begin   
  Result:=-1;
  for i:=1 to vd do
    if(Dogodki[i].dog=dog)and(Dogodki[i].igr=igr)then
      begin
        Result:=i;
        break;
      end;
end;

procedure CreateImage(H,W,L,T: Integer;var im: Timage);
begin
  im:=TImage.Create(FormIgra);
  im.Stretch:=True;
  With im do
    begin
      Parent:=FormIgra;
      Height:=H;
      Width:=W;
      Left:=L;
      Top:=T;
    end;
end;

procedure PredvajajEfekt(f: string);
begin
  //mciSendString(PChar('close sound'+inttostr(sou)),nil,0,0);
  mciSendString(PChar('open '+f+' type waveaudio alias sound'+inttostr(sou)),nil,0,0);
  mciSendString(PChar('play sound'+inttostr(sou)), nil, 0, 0);
  sou:=sou+1;
  if sou>9999 then
    sou:=0;
end;

function KeyDow(Key: Word) :Boolean;
begin
  Result:=(GetKeyState(Key) and $80) = $80;
end;

function EksplBlok(b: TPolje) :Boolean;
begin
  Result:=(b=Prazno)or(b=UniBlok)or((Ru<=b)and(b<=Be))or(b=Obl)or(b=SenzBom)or(b=Past)or(b=VelBom);
end;

function HodljivBlok(b: TPolje) :Boolean;
begin
  Result:=(b=Prazno)or((Ru<=b)and(b<=Be))or(b=Obl)or(b=SenzBom)or(b=Past)or(b=VelBom);
end;

procedure Pocisti(i: Integer);
begin
  Igralci[i].diam:=Prazno;
  ImDiam[i].Picture.LoadFromFile('slike\nic'+inttostr(i)+'.png');
  Igralci[i].moc:=0;
  ImMoci[i].Picture.LoadFromFile('slike\nic'+inttostr(i)+'.png');
  ImKaz[i].Picture.LoadFromFile('slike\nic'+inttostr(i)+'.png');
end;

procedure ZbijZiv(ig: Integer);
begin
  Igralci[ig].ziv:=max(0,Igralci[ig].ziv-1);
  ImSrca[ig].Picture.LoadFromFile('slike\'+inttostr(Igralci[ig].ziv)+'z.png');
  Pocisti(ig);
  if Igralci[ig].ziv=0 then
    begin
      ImObrazi[ig].Picture.LoadFromFile('slike\mban'+inttostr(ig)+'.png');
      ImIgralci[ig].Picture.LoadFromFile('slike\bannev'+inttostr(ig)+'.png');
      Igralci[ig].stanja[Mrtev]:=True;
      if Igralci[ig].stanja[Deton] then
        begin
          Igralci[ig].stanja[Deton]:=False;
          Polje[Igralci[ig].dx,Igralci[ig].dy]:=Prazno;
        end;
    end
  else
    begin
      PredvajajEfekt('glasba\ban5.wav');
      Igralci[ig].stanja[Coold]:=True;
      ImIgralci[ig].Picture.LoadFromFile('slike\banc'+inttostr(ig)+'.png');
      DodajDogodek(20,ig,Cool,0,0);
    end;
end;

procedure Eksplozija(x,y,ig: Integer);
var i: Integer;
begin
  Polje[x,y]:=Obl;
  ImPolje[x,y].Picture.LoadFromFile('slike\eks.png');
  DodajDogodek(5,ig,Ekspl,x,y);
  for i:=1 to stig do
    if (Polje[Igralci[i].x,Igralci[i].y]=Obl)and(not Igralci[i].stanja[Mrtev])and(not Igralci[i].stanja[Coold])and(not Igralci[i].stanja[Odb])and(not Igralci[i].stanja[Mav]) then
      ZbijZiv(i)
    else if (Polje[Igralci[i].x,Igralci[i].y]=Obl)and(Igralci[i].stanja[Odb])and(not Igralci[ig].stanja[Mrtev])and(not Igralci[ig].stanja[Coold])and(not Igralci[ig].stanja[Odb]) then
      ZbijZiv(ig);
end;

procedure Napadi(ig: Integer);
var i: Integer;
begin
  for i:=1 to stig do
    if (i<>ig)and(not Igralci[i].stanja[Coold])and(not Igralci[i].stanja[Odb])and(not Igralci[i].stanja[Mav])and(Igralci[i].x=Igralci[ig].x)and(Igralci[i].y=Igralci[ig].y) then
      ZbijZiv(i);
end;

procedure Poberi(x,y,i: Integer);
var b: TPolje;
begin
  b:=Polje[x,y];
  if b=Be then
    begin
      Igralci[i].moc:=min(Igralci[i].moc+1,3);
      ImMoci[i].Picture.LoadFromFile('slike\'+inttostr(Igralci[i].moc)+'b.png');
    end
  else
    begin
      Igralci[i].diam:=b;
      ImDiam[i].Picture.LoadFromFile('slike\'+DatDiam[b]+'.png');
    end;
  if PoisciDogodek(x,y,Diam)<>-1 then
    Dogodki[PoisciDogodek(x,y,Diam)].cas:=-1;
  Polje[x,y]:=Prazno;
  ImPolje[x,y].Picture.LoadFromFile('slike\tla.png');
  if Igralci[i].diam<>Prazno then
    ImKaz[i].Picture.LoadFromFile('slike\'+bar[Igralci[i].diam]+'u'+inttostr(Igralci[i].moc)+'.png');//////
  if Igralci[i].moc=0 then
    ImMoci[i].Picture.LoadFromFile('slike\'+DatDiam[b]+'.png');
end;

procedure TFormIgra.TimerTipkeTimer(Sender: TObject);
var i,j,k,l,x,y,stu,sti,t: Integer;
    sx,sy,ndx,ndy: array[1..mstig] of Integer;
    st: TTipka;
    b: TPolje;
    ig: TIgralec;
begin
  //init sx,sy
  for i:=1 to stig do
    begin
      sx[i]:=Igralci[i].x;
      sy[i]:=Igralci[i].y;
      ndx[i]:=-2;
      ndy[i]:=-2;
    end;
  //Zbij ce v bloku
  for i:=1 to stig do
    if (not HodljivBlok(Polje[sx[i],sy[i]]))and(not Igralci[i].stanja[Duh])and(not Igralci[i].stanja[Coold]) then
      ZbijZiv(i);
  //Preveri zmagovalce
  stu:=0;
  sti:=0;
  for i:=1 to stig do
    if Igralci[i].ziv=0 then
      stu:=stu+1
    else
      sti:=i;
  if stu=stig-1 then
    begin
      for i:=1 to mstig do
        Igralci[i].stanja[Mrtev]:=True;
      Zmaga.Zmaga(sti);
      FormIgra.Close;
      TimerTipke.Enabled:=False;
    end;
  //CE IZENACENO
  //premiki
  for i:=1 to stig do
    for st:=Low(TTipka) to R do
      begin
        if KeyDow(Tipke[i,st]) then
          begin
            if Igralci[i].stanja[Mav] then
              ImIgralci[i].Picture.LoadFromFile('slike\mav'+Smeri[st]+'.png')
            else if Igralci[i].stanja[Odb] then
              ImIgralci[i].Picture.LoadFromFile('slike\banod'+Smeri[st]+inttostr(i)+'.png')
            else if Igralci[i].stanja[Duh] then
              ImIgralci[i].Picture.LoadFromFile('slike\banduh'+Smeri[st]+inttostr(i)+'.png')
            else if Igralci[i].stanja[Coold] then
              ImIgralci[i].Picture.LoadFromFile('slike\banc'+Smeri[st]+inttostr(i)+'.png')
            else if Igralci[i].stanja[Mrtev] then
              ImIgralci[i].Picture.LoadFromFile('slike\bannev'+Smeri[st]+inttostr(i)+'.png')
            else
              ImIgralci[i].Picture.LoadFromFile('slike\ban'+Smeri[st]+inttostr(i)+'.png');
            ndx[i]:=hitx[st];
            ndy[i]:=hity[st];
            sx[i]:=sx[i]+ndx[i];
            sy[i]:=sy[i]+ndy[i];
          end;
      end;
  //zaletavanja
  for i:=1 to stig do
    begin
      if Igralci[i].stanja[Ujet] then
        begin
          sx[i]:=Igralci[i].x;
          sy[i]:=Igralci[i].y;
        end;
      if Igralci[i].stanja[Mav] then
            Napadi(i);
      b:=Polje[sx[i],sy[i]];
      if b<>Prazno then
        begin
          if ((b=Blok)or(b=UniBlok))and(not Igralci[i].stanja[Mrtev])and(not Igralci[i].stanja[Duh]) then
            begin
              sx[i]:=Igralci[i].x;
              sy[i]:=Igralci[i].y;
            end;
          if (Ru<=b)and(b<=Be)and(not Igralci[i].stanja[Mrtev]) then
            Poberi(sx[i],sy[i],i);
          if (b=Past)and(not Igralci[i].stanja[Mrtev])and(not Igralci[i].stanja[Duh])and(not Igralci[i].stanja[Coold]) then
            begin
              if PoisciDogodek(sx[i],sy[i],Pas)<>-1 then
                Dogodki[PoisciDogodek(sx[i],sy[i],Pas)].cas:=-1;
              Igralci[i].stanja[Ujet]:=True;
              Polje[sx[i],sy[i]]:=Prazno;
              DodajDogodek(30,i,Pas,sx[i],sy[i]);
            end;
          if (b=SenzBom)and(not Igralci[i].stanja[Mrtev])and(not Igralci[i].stanja[Duh]) then
            begin                                                  /////////////////POPRAVI
              Eksplozija(sx[i],sy[i],IgrSenzBom[sx[i],sy[i]]);
              if not((Igralci[i].x=sx[i])and(Igralci[i].y=sy[i])) then
                if Igralci[i].stanja[Odb] then
                  ZbijZiv(IgrSenzBom[sx[i],sy[i]])
                else
                  ZbijZiv(i);
            end;
          if (b=VelBom)and(not Igralci[i].stanja[Mrtev])and(not Igralci[i].stanja[Duh]) then
            begin
              ig:=Igralci[IgrVelBom[sx[i],sy[i]]];
              Polje[sx[i],sy[i]]:=Prazno;
              if (sx[i]-2<=ig.x)and(sx[i]+2>=ig.x)and(sy[i]-2<=ig.y)and(sy[i]+2>=ig.y) then
                begin
                  Igralci[IgrVelBom[sx[i],sy[i]]].stanja[Coold]:=True;
                  DodajDogodek(3,IgrVelBom[sx[i],sy[i]],Cool,sx[i],sy[i]);
                end;
              for k:=sx[i]-2 to sx[i]+2 do
                for l:=sy[i]-2 to sy[i]+2 do
                  if EksplBlok(Polje[k,l]) then
                    Eksplozija(k,l,i);
            end;
        end;
    end;
  //case space
  for i:=1 to stig do
    if KeyDow(Tipke[i,A]) then
      begin
        x:=sx[i]+dx[i];
        y:=sy[i]+dy[i];
        if Igralci[i].stanja[Deton] then
          begin
            x:=Igralci[i].dx-1;
            y:=Igralci[i].dy-1;
            Igralci[i].stanja[Deton]:=False;
            for k:=x to x+2 do
              for l:=y to y+2 do
                if EksplBlok(Polje[k,l]) then
                  Eksplozija(k,l,i);
            ImObrazi[i].Picture.LoadFromFile('slike\zban'+inttostr(i)+'.png');
          end
        else case Igralci[i].diam of
          Rd:
            case Igralci[i].moc of
              0:
                begin
                  PredvajajEfekt('glasba\ban1.wav');
                  Pocisti(i);
                  if EksplBlok(Polje[x,y]) then
                    Eksplozija(x,y,i);
                end;
              1:
                begin
                  PredvajajEfekt('glasba\ban1.wav');
                  Pocisti(i);
                  for j:=1 to 5 do
                    if EksplBlok(Polje[sx[i]+j*dx[i],sy[i]+j*dy[i]]) then
                      Eksplozija(sx[i]+j*dx[i],sy[i]+j*dy[i],i)
                    else
                      break;
                end;
              2:
                begin
                  PredvajajEfekt('glasba\ban1.wav');
                  Pocisti(i);
                  for j:=1 to vel do
                    if EksplBlok(Polje[sx[i]+j*dx[i],sy[i]+j*dy[i]]) then
                      Eksplozija(sx[i]+j*dx[i],sy[i]+j*dy[i],i)
                    else
                      break;
                end;
              3:
                begin
                  PredvajajEfekt('glasba\ban1.wav');
                  Pocisti(i);
                  for k:=2 to vel-1 do
                    for l:=2 to vel-1 do
                      if EksplBlok(Polje[k,l])and(Random(1000)>700)and(not((Igralci[i].x=k)and(Igralci[i].y=l))) then
                        Eksplozija(k,l,i);
                end;
            end;
          Ru:
            case Igralci[i].moc of
              0:
                begin
                  PredvajajEfekt('glasba\ban2.wav');
                  Pocisti(i);
                  if (Polje[x,y]<>Blok)and(Polje[x,y]<>UniBlok) then
                    begin
                      Polje[x,y]:=Past;
                      ImPolje[x,y].Picture.LoadFromFile('slike\ol.png');
                    end;
                end;
              1:
                begin
                  PredvajajEfekt('glasba\ban2.wav');
                  Pocisti(i);
                  if (Polje[x,y]<>Blok)and(Polje[x,y]<>UniBlok) then
                    begin
                      Polje[x,y]:=SenzBom;
                      IgrSenzBom[x,y]:=i;
                      ImPolje[x,y].Picture.LoadFromFile('slike\tla.png');
                    end;
                end;
              2:
                begin
                  PredvajajEfekt('glasba\ban2.wav');
                  Pocisti(i);
                  if (Polje[x,y]<>Blok)and(Polje[x,y]<>UniBlok) then
                    begin
                      Igralci[i].stanja[Deton]:=True;
                      Igralci[i].dx:=x;
                      Igralci[i].dy:=y;
                      ImPolje[x,y].Picture.LoadFromFile('slike\tla.png');
                      Polje[x,y]:=Prazno;
                      if PoisciDogodek(x,y,Diam)<>-1 then
                        Dogodki[PoisciDogodek(x,y,Diam)].cas:=-1;
                      ImObrazi[i].Picture.LoadFromFile('slike\banr'+inttostr(i)+'.png');
                    end;
                end;
              3:
                begin
                  PredvajajEfekt('glasba\ban2.wav');
                  Pocisti(i);
                  if (Polje[x,y]<>Blok)and(Polje[x,y]<>UniBlok) then
                    begin
                      Polje[x,y]:=VelBom;
                      ImPolje[x,y].Picture.LoadFromFile('slike\tla.png');
                      IgrVelBom[x,y]:=i;
                    end;
                end;
            end;
          Ze:
            case Igralci[i].moc of
              0:
                begin
                  PredvajajEfekt('glasba\ban3.wav');
                  Pocisti(i);
                  t:=NajdiDogodek(i,Pas);
                  if t<>-1 then
                    Dogodki[t].cas:=0;
                  for j:=1 to 4 do
                    begin
                      b:=Polje[sx[i]+dx[i],sy[i]+dy[i]];
                      if HodljivBlok(b) then
                        begin
                          if (Ru<=b)and(b<=Be) then
                            Poberi(sx[i]+dx[i],sy[i]+dy[i],i);
                          sx[i]:=sx[i]+dx[i];
                          sy[i]:=sy[i]+dy[i];
                        end
                      else
                        break;
                    end;
                end;
              1:
                begin 
                  PredvajajEfekt('glasba\ban3.wav');
                  Pocisti(i);
                  t:=NajdiDogodek(i,Pas);
                  if t<>-1 then
                    Dogodki[t].cas:=0;
                  for j:=1 to 8 do
                    begin
                      b:=Polje[sx[i]+dx[i],sy[i]+dy[i]];
                      if HodljivBlok(b) then
                        begin
                          if (Ru<=b)and(b<=Be) then
                            Poberi(sx[i]+dx[i],sy[i]+dy[i],i);
                          sx[i]:=sx[i]+dx[i];
                          sy[i]:=sy[i]+dy[i];
                        end
                      else
                        break;
                    end;
                end;
              2:
                begin
                  PredvajajEfekt('glasba\ban3.wav');
                  Pocisti(i);
                  t:=NajdiDogodek(i,Pas);
                  if t<>-1 then
                    Dogodki[t].cas:=0;
                  for j:=1 to vel do
                    begin
                      b:=Polje[sx[i]+dx[i],sy[i]+dy[i]];
                      if HodljivBlok(b) then
                        begin
                          if (Ru<=b)and(b<=Be) then
                            Poberi(sx[i]+dx[i],sy[i]+dy[i],i);
                          sx[i]:=sx[i]+dx[i];
                          sy[i]:=sy[i]+dy[i];
                        end
                      else
                        break;
                    end;
                end;
              3:
                begin
                  PredvajajEfekt('glasba\ban3.wav');
                  Pocisti(i);
                  t:=NajdiDogodek(i,Pas);
                  if t<>-1 then
                    Dogodki[t].cas:=0;
                  Igralci[i].stanja[Duh]:=True;
                  ImIgralci[i].Picture.LoadFromFile('slike\banduh'+inttostr(i)+'.png');
                  DodajDogodek(100,i,Duhd,sx[i],sy[i]);
                end;
            end;
          Mo:
            case Igralci[i].moc of
              0:
                begin
                  PredvajajEfekt('glasba\ban4.wav');
                  Pocisti(i);
                  Igralci[i].stanja[Coold]:=True;
                  ImIgralci[i].Picture.LoadFromFile('slike\banc'+inttostr(i)+'.png');
                  DodajDogodek(30,i,Cool,sx[i],sy[i]);
                end;
              1:
                begin
                  PredvajajEfekt('glasba\ban4.wav');
                  Pocisti(i);
                  Igralci[i].stanja[Coold]:=True;
                  ImIgralci[i].Picture.LoadFromFile('slike\banc'+inttostr(i)+'.png');
                  DodajDogodek(60,i,Cool,sx[i],sy[i]);
                end;
              2:
                begin
                  PredvajajEfekt('glasba\ban4.wav');
                  Pocisti(i);
                  Igralci[i].stanja[Odb]:=True;
                  Igralci[i].stanja[Coold]:=True;
                  ImIgralci[i].Picture.LoadFromFile('slike\banod'+inttostr(i)+'.png');
                  DodajDogodek(60,i,Odbd,sx[i],sy[i]);
                  DodajDogodek(60,i,Cool,sx[i],sy[i]);
                end;
              3:
                begin
                  PredvajajEfekt('glasba\ban4.wav');
                  Pocisti(i);
                  Igralci[i].stanja[Odb]:=True;
                  Igralci[i].stanja[Coold]:=True;
                  Igralci[i].stanja[Mav]:=True;
                  ImIgralci[i].Picture.LoadFromFile('slike\mav.png');
                  DodajDogodek(60,i,Odbd,sx[i],sy[i]);
                  DodajDogodek(60,i,Cool,sx[i],sy[i]);
                  DodajDogodek(60,i,Mavd,sx[i],sy[i]);
                end;
            end;
        end;
      end;
  for i:=1 to stig do
    begin
      sx[i]:=min(vel,max(sx[i],1));
      sy[i]:=min(vel,max(sy[i],1));
      ImIgralci[i].Left:=zam+velb*(sx[i]-1);
      ImIgralci[i].Top:=(sy[i]-1)*velb;
      Igralci[i].x:=sx[i];
      Igralci[i].y:=sy[i];
      if ndx[i]<>-2 then
        dx[i]:=ndx[i];
      if ndy[i]<>-2 then
        dy[i]:=ndy[i];
    end;

end;

{ TFormIgra }

procedure TFormIgra.FormShow(Sender: TObject);
var i,j: Integer;
    st: TStanje;
begin
  //init dogodki
  for i:=1 to 4*vel*vel do
    Dogodki[i].cas:=-1;
  //init kazalci
  for i:=1 to stig do
    begin
      ImKazOzad[i].Picture.LoadFromFile('slike\bano'+inttostr(i)+'.png');
      ImObrazi[i].Picture.LoadFromFile('slike\zban'+inttostr(i)+'.png');
      ImSrca[i].Picture.LoadFromFile('slike\3z.png');
      ImDiam[i].Picture.LoadFromFile('slike\nic'+inttostr(i)+'.png');
      ImMoci[i].Picture.LoadFromFile('slike\nic'+inttostr(i)+'.png');
      ImKaz[i].Picture.LoadFromFile('slike\nic'+inttostr(i)+'.png');
    end;
  //init mrtvi kazalci
  if stig<mstig then
    for i:=stig+1 to mstig do
      begin
        ImKazOzad[i].Picture.LoadFromFile('slike\nic.png');
        ImObrazi[i].Picture.LoadFromFile('slike\nic.png');
        ImSrca[i].Picture.LoadFromFile('slike\nic.png');
        ImDiam[i].Picture.LoadFromFile('slike\nic.png');
        ImMoci[i].Picture.LoadFromFile('slike\nic.png');
        ImKaz[i].Picture.LoadFromFile('slike\nic.png');
      end;
  //init polje
  if StZem=0 then
    Polje:=UnitZem.Zem[random(4)+1]
  else
    Polje:=UnitZem.Zem[StZem];
  //init slike polja
  for i:=1 to vel do
    for j:=1 to vel do
      ImPolje[i,j].Picture.LoadFromFile('slike\'+DatPolja[Polje[i,j]]+'.png');
  //init igralce
  for i:=1 to stig do
    With Igralci[i] do
      begin
        ziv:=3;
        diam:=Prazno;
        moc:=0;
        deton:=False;
        x:=xi[i];
        y:=yi[i];
        for st:=Low(TStanje) to High(TStanje) do
          stanja[st]:=False;
      end;
  //init slike igralcev
  for i:=1 to stig do
    begin
      ImIgralci[i].Show;
      ImIgralci[i].Picture.LoadFromFile('slike\ban'+inttostr(i)+'.png');
    end;
  //init mrtve igralce
  if stig<mstig then
    for i:=stig+1 to mstig do
      begin
        Igralci[i].ziv:=0;
        Igralci[i].stanja[Mrtev]:=True;
        ImIgralci[i].Hide;
      end;
  //sprozi timerja
  TimerIgra.Enabled:=True;
  TimerTipke.Enabled:=True;
end;

procedure TFormIgra.FormCreate(Sender: TObject);
var i,j,a: Integer;
begin
  randomize;
  //init kazalci
  for i:=1 to stig do
    begin
      a:=(zam-2*z-p)div 2;
      CreateImage(zam,zam,0,(i-1)*zam,ImKazOzad[i]);

      CreateImage(a,a,z,(i-1)*zam+z,ImObrazi[i]);
      CreateImage(a,a,z+p+a,(i-1)*zam+z,ImSrca[i]);

      CreateImage(a,a,z,(i-1)*zam+z+p+a,ImDiam[i]);
      CreateImage(a,a,z,(i-1)*zam+z+p+a,ImMoci[i]);
      CreateImage(a,a,z+p+a,(i-1)*zam+z+p+a,ImKaz[i]);
    end;
  nal:=nal+1;
  //init tla
  for i:=1 to vel-2 do
    for j:=1 to vel-2 do
      begin
        CreateImage(velb,velb,zam+i*velb,j*velb,Ozadje[i,j]);
        Ozadje[i,j].Picture.LoadFromFile('slike\tla.png');
      end;
  nal:=nal+1;
  //init slike polja
  for i:=1 to vel do
    for j:=1 to vel do
      CreateImage(velb,velb,zam+(i-1)*velb,(j-1)*velb,ImPolje[i,j]);
  //init slik igralcev
  for i:=1 to stig do
    begin
      CreateImage(velb,velb,zam+(Igralci[i].x-1)*velb,(Igralci[i].y-1)*velb,ImIgralci[i]);
    end;
  nal:=nal+1;
end;

procedure TFormIgra.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var i: Integer;
begin
  for i:=1 to mstig do
    Igralci[i].stanja[Mrtev]:=True;
  TimerTipke.Enabled:=False;
end;

function JeDiam(p: TPolje) :Boolean;
begin
  Result:=(p>=Ru)and(p<=Be);
end;

procedure TFormIgra.TimerIgraTimer(Sender: TObject);
var dia: TPolje;
    i,x,y: Integer;
begin
  //ustvari diam.
  if random(1000)>950 then
    begin
      repeat
        x:=random(vel-1)+1;
        y:=random(vel-1)+1;
      until Polje[x,y]=Prazno;
      dia:=di[random(5)+1];
      Polje[x,y]:=dia;
      ImPolje[x,y].Picture.LoadFromFile('slike\'+DatPolja[dia]+'.png');
      DodajDogodek(40,0,Diam,x,y);
    end;
  //odstej cas za dogodke in reagiraj nanje
  for i:=1 to 4*vel*vel do
    if Dogodki[i].cas>-1 then
      begin
        case Dogodki[i].dog of
          Diam:
            if (Dogodki[i].cas=0)and JeDiam(Polje[Dogodki[i].x,Dogodki[i].y]) then
              begin
                Polje[Dogodki[i].x,Dogodki[i].y]:=UniBlok;
                ImPolje[Dogodki[i].x,Dogodki[i].y].Picture.LoadFromFile('slike\ubl.png');
              end;
          Ekspl:
            if Dogodki[i].cas=0 then
              begin
                Polje[Dogodki[i].x,Dogodki[i].y]:=Prazno;
                ImPolje[Dogodki[i].x,Dogodki[i].y].Picture.LoadFromFile('slike\tla.png');
              end;
          Cool:
            if Dogodki[i].cas=0 then
              begin
                Igralci[Dogodki[i].igr].stanja[Coold]:=False;
                ImIgralci[Dogodki[i].igr].Picture.LoadFromFile('slike\ban'+inttostr(Dogodki[i].igr)+'.png');
              end;
          Pas:
            if Dogodki[i].cas=0 then
              begin
                Igralci[Dogodki[i].igr].stanja[Ujet]:=False;
                ImPolje[Dogodki[i].x,Dogodki[i].y].Picture.LoadFromFile('slike\tla.png');
              end;
          Duhd:
            if Dogodki[i].cas=0 then
              begin
                Igralci[Dogodki[i].igr].stanja[Duh]:=False;
                ImIgralci[Dogodki[i].igr].Picture.LoadFromFile('slike\ban'+inttostr(Dogodki[i].igr)+'.png');
                Igralci[Dogodki[i].igr].stanja[Coold]:=True;
                DodajDogodek(20,Dogodki[i].igr,Cool,0,0);
              end;
          Odbd:
            if Dogodki[i].cas=0 then
              begin
                Igralci[Dogodki[i].igr].stanja[Odb]:=False;
                ImIgralci[Dogodki[i].igr].Picture.LoadFromFile('slike\ban'+inttostr(Dogodki[i].igr)+'.png');
              end;
          Mavd:
            if Dogodki[i].cas=0 then
              begin
                Igralci[Dogodki[i].igr].stanja[Mav]:=False;
                ImIgralci[Dogodki[i].igr].Picture.LoadFromFile('slike\ban'+inttostr(Dogodki[i].igr)+'.png');
              end;
        end;
        Dogodki[i].cas:=Dogodki[i].cas-1;
      end;
end;

end.


unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,umonopoly, StdCtrls,ScktComp;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  monop:tmonopoly;
implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
if edit1.text='start' then monop.spielstart;
if edit1.Text='stop' then
Begin
monop.destroy;
halt;
end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var server:tserversocket;
begin
monop:=tmonopoly.create;
server:=tserversocket.Create(form1);
server.Port:=1337;
monop.setserversocket(server);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
monop.setlosgeld(strtoint(edit1.Text));
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
monop.setkaution(strtoint(edit1.Text));
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
OpenDialog1.execute;
monop.einlesen(opendialog1.FileName);
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
var s,t:string;
ende:boolean;
var int:integer;
begin
if ord(key)=13 then
Begin
ende:=false;
t:=edit1.Text;
s:='';
edit1.Text:='';
while (t<>'') and (ende=false) do
Begin
s:=s+t[1];
delete(t,1,1);

if s='start' then
  Begin
  monop.spielstart;
  ende:=true;
  end;
if s='stop' then
  Begin
  monop.destroy;
  ende:=true;
  end;
if s='set losgeld' then
  Begin
  delete(t,1,1);
  int:=strtoint(t);
  monop.setlosgeld(int);
  ende:=true;
  end;
if s='set kaution' then
  Begin
  delete(t,1,1);
  int:=strtoint(t);
  monop.setkaution(int);
  ende:=true;
  end;
if s='set losgeld' then
  Begin
  delete(t,1,1);
  int:=strtoint(t);
  monop.startgeld:=int;
  ende:=true;
  end;
if s='read brett' then
  Begin
  OpenDialog1.execute;
  monop.einlesen(opendialog1.FileName);
  ende:=true;
  end;


end;
end;
end;

end.

program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  uKommunikation in 'uKommunikation.pas',
  uNetzwerk in 'uNetzwerk.pas',
  uguivecht in 'uguivecht.pas',
  uclient in 'uClient.pas',
  uVirtualAnimation in 'uVirtualAnimation.pas',
  uangebot in 'uangebot.pas',
  UFeld in 'UFeld.pas',
  UMonopoly in 'uMonopoly.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

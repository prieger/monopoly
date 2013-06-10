program Monopoly;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  UMonopoly in 'UMonopoly.pas',
  uguivirtuell in 'uguivirtuell.pas',
  uangebot in '\\LOGOSRV\tausch\Projekt nu_lk-inf\UMonopoly Phillip\uangebot.pas',
  uKommunikation in '\\LOGOSRV\tausch\Projekt nu_lk-inf\UMonopoly Phillip\nichts kopieren\uKommunikation.pas',
  uNetzwerk in '\\LOGOSRV\tausch\Projekt nu_lk-inf\UMonopoly Phillip\nichts kopieren\uNetzwerk.pas',
  UEreignis in '\\LOGOSRV\tausch\Projekt nu_lk-inf\UMonopoly Phillip\nichts kopieren\UEreignis.pas',
  UFeld in '\\LOGOSRV\tausch\Projekt nu_lk-inf\UMonopoly Phillip\nichts kopieren\UFeld.pas',
  uclient in '\\LOGOSRV\tausch\Projekt nu_lk-inf\UMonopoly Phillip\uclient.pas',
  uVirtualAnimation in '\\LOGOSRV\tausch\Projekt nu_lk-inf\UMonopoly Phillip\uVirtualAnimation.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

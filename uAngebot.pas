unit uangebot;

interface
uses SysUtils;
type
TAngebot = class
  Strassengeben:Array of integer;
  //Arrays
  Strassennehmen:Array of integer;
  anzG:integer;
  //Anzahl an Straßen die ssender, also derjenige, der das Angebot macht gibt
  anzN:integer;
    //Anzahl an Straßen die sempf, also derjenige, der das Angebot bekommt gibt
  GefKarten:Integer;
  //Anzahl an du kommst aus dem Gefängnis frei karten, die der Empfänger bekommt
  //wenn der Angebotsmacher Karten erhällt ist diese Zahl negativ
  Geld: integer;
    //Geld, dass der Empfänger bekommt wenn der Angebotsmacher Geld erhällt ist diese Zahl negativ
  sempf:integer;
  //id desjenigen, an den sich das Angebot richtet
  ssender:integer;
  //id des Spielers, der das Angebot gemacht hat
  constructor create;overload;
  constructor create(from : string); overload;//muss noch implementiert werden
  (* Vor.: Das Obbjekt ist noch nicht kreiert
     Eff.: Die Instanz hat die gleichen Inhalte wie die Instanz, aus der der
     String kommt *)


  function toString : string;
  (* erzeugt einen Netzwerkfähigen String, der an den Constructor übergeben
     werden kann *)
end;

implementation

constructor tangebot.create(from:string);
Begin

end;

function TAngebot.toString : string;
var
	buf: string;
	i: integer;
	len : integer;
begin

	len := length(strassengeben);
	buf := inttostr(len);
	i   := 1;

	while i <= len do
	begin
		buf := buf + '|' + inttostr(strassengeben[i]);
		inc(i);
	end;

	len := length(strassennehmen);
	buf :=buf+ '|' + inttostr(len);
	i   := 1;

	while i <= len do
	begin
		buf := buf + '|' + inttostr(strassennehmen[i]);
		inc(i);
	end;

	buf := buf + '|' + inttostr(GefKarten) + '|' + inttostr(Geld) + '|' + inttostr(ssender);

	toString := buf;
end;

constructor TAngebot.create;
BEGIN
setlength(strassengeben,0);
setlength(strassennehmen,0);
anzG:=0;
anzN:=0;
GefKarten:=0;
Geld:=0;
sempf:=0;
ssender:=0;

END;

end.

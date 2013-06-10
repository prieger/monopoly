unit UEreignis; //enthält Ereignisprozeduren

interface
//uses uMonopoly;
type TEreignis = procedure(var spiel:TObject); //Ereignisse sind Prozeduren, in denen das TMonopoly-Spiel als variabler Parameter verändert wird. Zu den Ereignissen zählen das Geschehen auf den Eckfeldern genauso wie die Aktionen von Ereignis- und Gemeinschaftskarten.
type TKarte = class //einzelne Karte als Teil einer Warteschlange mit einem festgelegten Ereignis
  Inhalt : TEreignis; //eigentliche Ereignisprozedur
  Text : String; //Text auf der Ereignis-/Gemeinschaftskarte
  Vorgaenger : TKarte; //Vorgängerkarte ín der Warteschlange
  Nachfolger : TKarte; //Nachfolgerkarte in der Warteschlange
  constructor create (parInhalt : TEreignis; parText : String);
end;
type TWarteschlange = class //Typ für Warteschlangen von Karten (eigentlich ein Kartenstapel). Es gibt im Spiel mehrere Warteschlangen dieser Art (Ereigniskartenschlange, Gemeinschaftskartenschlange, ...)
  public
  Karte : TKarte; //oberste (=nächste) Karte in der Warteschlange
  constructor create;
  procedure Hinzufuegen (parKarte : TKarte);
  function KarteZiehen : TKarte; //Karte wird gezogen und ein Zeiger darauf zurückgegeben, Karte kommt kommt ans Ende der Warteschlange
  procedure LetzteKarteHerausnehmen;
end;

implementation
uses uFeld, uMonopoly;

//TKarte

constructor TKarte.create(parInhalt : TEreignis; parText : String);
begin
  Inhalt := parInhalt;
  Text := parText;
  Vorgaenger := NIL;
  Nachfolger := NIL;
end;

//TWarteschlange, implementiert als doppelt verkettete Ringliste

constructor TWarteschlange.Create();
begin
  Karte := NIL;
end;

procedure TWarteschlange.Hinzufuegen(parKarte : TKarte);
begin
  If Karte = NIL Then
  begin
    Karte:=parKarte;
    Karte.Vorgaenger := Karte;
    Karte.Nachfolger := Karte;
    //Boden:=parKarte;
  end
  else
  begin
    parKarte.Vorgaenger := Karte.Vorgaenger;
    parKarte.Nachfolger := Karte;
    Karte.Vorgaenger.Nachfolger := parKarte;
    Karte.Vorgaenger := parKarte;
  end;
end;

function TWarteschlange.KarteZiehen : TKarte;
begin
  result := Karte;
  Karte := Karte.Nachfolger;
end;

procedure TWarteschlange.LetzteKarteHerausnehmen;
begin
  Karte.Vorgaenger.Vorgaenger.Nachfolger := Karte;
  Karte.Vorgaenger := Karte.Vorgaenger.Vorgaenger;
end;

//Hier folgen Ereignisprozeduren vom Typ TEreignis.

procedure Los (var spiel : TMonopoly);
begin
  spiel.Spieler[spiel.AktSpieler].Geld := spiel.Spieler[spiel.AktSpieler].Geld + spiel.losgeld; //200€ wenn auf Los
end;

procedure FreiParken(var spiel : TMonopoly);
begin
  spiel.Spieler[spiel.AktSpieler].Geld := spiel.Spieler[spiel.AktSpieler].Geld + spiel.frei_parken;
  spiel.frei_parken := 0;
  spiel.akts_freiparken;
end;

procedure GeheInDasGefaengnis(var spiel : TMonopoly);
begin
  spiel.Spieler[spiel.AktSpieler].Feld := 10; //vorläufige Position des Gefängnisse
  spiel.Spieler[spiel.AktSpieler].gefangen := true;
end;

procedure GefaengnisFrei(var spiel : TMonopoly);
begin
  //spiel.Spieler[spiel.AktSpieler].
end;

//Ereigniskarten

//Mache einen Ausflug nach dem Südbahnhof und wenn du über Los kommst, ziehe 200$ ein.
Procedure Ereignis01(var spiel:TMonopoly);
Begin
  spiel.Ziehen((5-spiel.spieler[spiel.aktspieler].feld) mod spiel.maxstr);
end;

//Gehe 3 Felder vor.
Procedure Ereignis02(var spiel:TMonopoly);
begin
  spiel.ziehen(3);
end;

//Gehe zurück zur Badstraße.
Procedure Ereignis03(var spiel:TMonopoly);
Begin
  spiel.Spieler[spiel.aktspieler].Feld:=1;
end;

//Gehe vor bis zur Seestrasse, wenn du über Los kommst, ziehe 200$ ein.
Procedure Ereignis04(var spiel:TMonopoly);
Begin
	spiel.Ziehen((11-spiel.spieler[spiel.aktspieler].feld) mod spiel.maxstr);
end;

//Gehe vor bis zum Opernplatz, wenn du über Los kommst, ziehe 200$ ein.
Procedure Ereignis05(var spiel:TMonopoly);
Begin
        spiel.Ziehen((24-spiel.spieler[spiel.aktspieler].feld) mod spiel.maxstr);
end;

//Gehe ins Gefängnis. Begib dich direkt dorthin, gehe nicht über Los und ziehe nicht 200$ ein.
Procedure Ereignis06(var spiel:TMonopoly);
Begin
	spiel.spieler[spiel.aktspieler].gefangen:=TRUE;
        //???
	spiel.spieler[spiel.aktspieler].Feld:=10;
end;

//Rücke bis auf Los vor.
Procedure Ereignis07(var spiel:TMonopoly);
Begin
        spiel.Ziehen((-spiel.spieler[spiel.aktspieler].feld) mod spiel.maxstr);
end;

//Du bekommst eine "Du kommst aus dem Gefängnis frei"-Karte.
procedure Ereignis08(var spiel:TMonopoly);
begin
  inc(spiel.Spieler[spiel.AktSpieler].AnzGefKarten);
  spiel.Ereignis.LetzteKarteHerausnehmen;
end;

//Rücke vor bis zum nächsten Bahnhof. Dei Eigentümer erhält das doppelte der normalen Miete.
Procedure Ereignis09(var spiel:TMonopoly);
Begin

spiel.Ziehen((-spiel.spieler[spiel.aktspieler].feld-(spiel.maxstr div 8)) mod (spiel.maxstr div 4));
IF TBesitz(spiel.felder[spiel.spieler[spiel.aktspieler].Feld]).besitzer>-1 THEN
begin
  spiel.spieler[spiel.aktspieler].geld := spiel.spieler[spiel.aktspieler].geld - TBesitz(spiel.felder[spiel.spieler[spiel.aktspieler].Feld]).getmiete(0);
  spiel.spieler[TBesitz(spiel.felder[spiel.spieler[spiel.aktspieler].Feld]).Besitzer].Geld := spiel.spieler[TBesitz(spiel.felder[spiel.spieler[spiel.aktspieler].Feld]).Besitzer].Geld + TBesitz(spiel.felder[spiel.spieler[spiel.aktspieler].Feld]).getmiete(0);
end;
end;


//Miete und Anleihezinsen werden fällig. Die Bank zahlt dir 150€
Procedure Ereignis10(var spiel:TMonopoly);
Begin
  spiel.spieler[spiel.aktspieler].geld := spiel.spieler[spiel.aktspieler].geld+150;
end;
//Die Bank zahlt dir eine Dividende von 50€
Procedure Ereignis11(var spiel:TMonopoly);
Begin
  spiel.spieler[spiel.aktspieler].geld := spiel.spieler[spiel.aktspieler].geld+50;
end;

//Lasse alle deine Häuser renovieren. Zahle an die Bank für jedes Haus 20€ und für jedes Hotel 100€
Procedure Ereignis12(var spiel:TMonopoly);
var akk,i:integer;
Begin
        akk:=0;
	for i:=0 to (spiel.spieler[spiel.aktspieler].besitzanzahl-1) Do
	Begin
	  IF spiel.spieler[spiel.aktspieler].besitz[i].zustand>=0 THEN INC(akk,spiel.spieler[spiel.aktspieler].besitz[i].zustand)
	end;
	spiel.spieler[spiel.aktspieler].geld := spiel.spieler[spiel.aktspieler].geld - akk*20;
        INC(spiel.frei_parken, akk*20);
        spiel.akts_freiparken;
end;

//Strafe für zu schnelles Fahren. Zahle 15€
Procedure Ereignis13(var spiel:TMonopoly);
Begin
	spiel.spieler[spiel.aktspieler].geld := spiel.spieler[spiel.aktspieler].geld - 15;
        INC(spiel.frei_parken, 15);
        spiel.akts_freiparken;
end;

//Rücke vor bis zur Schlossallee
Procedure Ereignis14(var spiel:TMonopoly);
Begin
  spiel.Ziehen((40-spiel.spieler[spiel.aktspieler].feld) mod spiel.maxstr);
end;

//Du wurdest zum Vorstand gewählt: Zahle jedem Spieler 50€
Procedure Ereignis15(var spiel:TMonopoly);
var i:integer;
Begin
	For i:=0 to (spiel.Spieleranzahl - 1) DO
	Begin
		spiel.spieler[i].geld := spiel.spieler[i].geld + 50;
		spiel.spieler[spiel.aktspieler].geld := spiel.spieler[spiel.aktspieler].geld - 50;
	end;
end;

//Zahle eine Strafe von 10€.
Procedure Ereignis16(var spiel:TMonopoly);
Begin
  spiel.spieler[spiel.aktspieler].geld := spiel.spieler[spiel.aktspieler].geld - 10;
  INC(spiel.frei_parken, 10);
  spiel.akts_freiparken;
end;


//Gemeinschaftskarten

//Du hast in einem Kreuzworträtselwettbewerb gewonnen. Ziehe 100€ ein
Procedure Gemeinschaft01(var spiel:TMonopoly);
Begin
  spiel.Spieler[spiel.aktspieler].geld := spiel.Spieler[spiel.aktspieler].geld + 100;
end;
//Du bekommst eine "du kommst aus dem Gefängnis frei"-Karte.
Procedure Gemeinschaft02(var spiel:TMonopoly);
begin
  inc(spiel.Spieler[spiel.AktSpieler].AnzGefKarten);
  spiel.Gemeinschaft.LetzteKarteHerausnehmen;
end;

//Arzt-Kosten. Zahle 50€
Procedure Gemeinschaft03(var spiel:TMonopoly);
Begin
	spiel.Spieler[spiel.aktspieler].geld := spiel.Spieler[spiel.aktspieler].geld - 50;
        INC(spiel.frei_parken, 50);
        spiel.akts_freiparken;
end;

//Zahle Schulgeld 150€
Procedure Gemeinschaft04(var spiel:TMonopoly);
Begin
	spiel.Spieler[spiel.aktspieler].geld := spiel.Spieler[spiel.aktspieler].geld - 150;
        INC(spiel.frei_parken, 150);
        spiel.akts_freiparken;
end;

//Einkommenssteuer-Rückzahlung. Ziehe 20€ ein
Procedure Gemeinschaft05(var spiel:TMonopoly);
Begin
	spiel.Spieler[spiel.aktspieler].Geld := spiel.Spieler[spiel.aktspieler].Geld + 20;

end;

//Du wirst zu Strassenausbesserungsarbeiten herangezogen.Zahle für deine Häuser und Hotels. 40€ je Haus, 200€ je Hotel an die Bank
Procedure Gemeinschaft06(var spiel:TMonopoly);
var akk,i:integer;
Begin
        akk := 0;
  	for i:=0 to (spiel.spieler[spiel.aktspieler].besitzanzahl - 1) Do
	Begin
	  IF spiel.spieler[spiel.aktspieler].besitz[i].zustand>=0 THEN INC(akk,spiel.spieler[spiel.aktspieler].besitz[i].zustand)
	end;
	spiel.spieler[spiel.aktspieler].geld := spiel.spieler[spiel.aktspieler].geld - akk*40;
        INC(spiel.frei_parken, akk*40);
        spiel.akts_freiparken;

end;

//Du hast den 2. Preis in einer Schönheitskonkurrenz gewonnen. Ziehe 10€ ein.
Procedure Gemeinschaft07(var spiel:TMonopoly);
Begin
	spiel.Spieler[spiel.aktspieler].geld := spiel.Spieler[spiel.aktspieler].geld + 10;
end;

//Zahle an das Krankenhaus 100€
Procedure Gemeinschaft08(var spiel:TMonopoly);
Begin
	spiel.Spieler[spiel.aktspieler].geld := spiel.Spieler[spiel.aktspieler].geld - 100;
        INC(spiel.frei_parken, 100);
        spiel.akts_freiparken;
end;

//Rücke vor bis auf Los.
Procedure Gemeinschaft09(var spiel:TMonopoly);
Begin
  Ereignis07(spiel);
end;

//Du erbst 100€
Procedure Gemeinschaft10(var spiel:TMonopoly);
Begin
  spiel.Spieler[spiel.aktspieler].geld := spiel.Spieler[spiel.aktspieler].geld + 100;
end;

//Gehe ins Gefängnis. Begib dich direkt dorthin, gehe nicht über Los und ziehe nicht 200€ ein.
Procedure Gemeinschaft11(var spiel:TMonopoly);
Begin
  Ereignis06(spiel);
end;

//Bank-Irrtum zu deinen Gunsten. Ziehe 200€ ein.
Procedure Gemeinschaft12(var spiel:TMonopoly);
Begin
  spiel.Spieler[spiel.aktspieler].geld := spiel.Spieler[spiel.aktspieler].geld + 200;
end;

//Aus Lagerverkäufen erhältst du 25€
Procedure Gemeinschaft13(var spiel:TMonopoly);
Begin
spiel.Spieler[spiel.aktspieler].geld := spiel.Spieler[spiel.aktspieler].geld + 25;
end;

//DU erhältst auf Vorzugs-Aktien 7% Dividende 45€
Procedure Gemeinschaft14(var spiel:TMonopoly);
Begin
spiel.Spieler[spiel.aktspieler].geld := spiel.Spieler[spiel.aktspieler].geld + 45;
end;

//Die Jahresrente wird fällig. Ziehe 100€ ein
Procedure Gemeinschaft15(var spiel:TMonopoly);
Begin
	spiel.Spieler[spiel.aktspieler].geld := spiel.Spieler[spiel.aktspieler].geld + 100;
end;

//Es ist dein Geburtstag. ziehe von jedem Spieler 50€ ein
Procedure Gemeinschaft16(var spiel:TMonopoly);
var i:integer;
Begin
For i:=0 to (spiel.Spieleranzahl - 1) DO
Begin
	spiel.spieler[i].geld := spiel.spieler[i].geld - 50;
	spiel.spieler[spiel.aktspieler].geld := spiel.spieler[spiel.aktspieler].geld + 50;
end;
end;




end.

unit UMonopoly;

interface

USES UEreignis,Ufeld,uKommunikation,Variants , ScktComp,SysUtils,uangebot,
  Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls;

type
Farbenbesitz=record
Besitzer:integer;
Farbe:tcolor;
end;


TMonopoly = Class
private
  nach_kp:integer;
  Flosgeld:integer;
  (* Speichert Geldbetrag, welchen der Spieler beim ziehen über Los erhällt.
     Lesezugriff über Property losgeld*)
  frei_Geld:integer;
  (* Speichert Preis für die Kaution;Lese zugriff wird über die Property
     preis_freikauf´*)
  Spielgestartet:boolean;
  //Gibt an ob das Spiel schon läuft
  Augenzahl:integer;
  //Summe der Augen beim letzten Würfeln
  pasch:integer;
  //Anzahl der Päsche
  echtaktspieler:integer;
  //Wird in der Prozedure Kontoplus benutzt, kann nicht lokal gemacht werden
  ang:Tangebot;
  //Speichert aktuelles Angebot welches grade unterbreitet wurde
  procedure FeldEintragAuswerten(zeile:String;ID:integer);
  (* Liest das Spielbrett mit dem Namen Felder.csv ein, diese muss im selben
     Verzeichnis wie das Spiel liegen *)
  procedure kontoplus;
  public
  startgeld:integer;
  //Geld was jeder Spieler bei Spielstart erhällt
  netz:tserver;
  //Speichert ob das Spiel gestartet wurde
  Felder : array of TFeld; //Los hat den Index 0
  Spieleranzahl : integer;
  //hat bei 0 Spielern den Wert 0
  Spieler: array of Tspieler;
  Ereignis, Gemeinschaft:Twarteschlange;
  //Warteschlangen für die Felder
  Gef:integer;
  //Gibt Position vom Gefängnisfeld an
  los:integer;
  gehgef:integer;
  //Gibt Position vom Feld gehe in das Gefängnis an
  frei:integer;
  //Gibt Position vom FreiParkenfeld an
  maxstr:integer;
  //gibt Länge vom Felderarray an; hat bei leerem Spielfeld einen negativen Wert
  frei_parken: Integer;
  // Geld in der Mitte
  AktSpieler :integer;
  //id des aktuellen Spielers
  Gruppenbesitz: Array of boolean;
  (* Speichert ob der Besitzer des Feldes, mit dem selben Index wie das Feld
     in FGruppenbesitz alle Felder dieser Farbe Besitzt *)
  property losgeld:Integer read Flosgeld;
  //Geld was jeder Spieler beim Überqueren vom Losfeld erhält
  property preis_freikauf:integer read frei_Geld;
  //Kaution für das Gefängnis
  property Spiellaeuft:boolean read Spielgestartet;
  procedure akts_freiparken;
  //Gibt den Geldbetrag in der Mitte an die Clients weiter
  procedure ziehe_EReignisskarte;
  //Zieht eine Ereignisskarte
  procedure zieheGemeinschaftskarte;
  //Zieht eine Gemeinschaftskarte
  procedure set_Spieler_pos(id,Feld:integeR);
  (* Setzt den Spieler mit dem Index id auf das Feld mit dem Index Feld, ohne
     Berücksichtigung des Feldes Los. Anschließend wird die neue Position an
     die Clients geschickt *)
  procedure set_Spieler_Geld(id, Geld:integer);
  (* Setzt den Geldstands des Spielers id auf den Betrag Geld und sendet dies
     an die Clients *)
  procedure akts_Besitz(id:Integer);
  (* Aktualisiert das Feld mit dem Index id auf allen Clients, wenn es eine Instanz
     von TBesitz ist *)
  procedure Nachricht_an_alle_spieler(Text:string);
  //Schickt den String Text an alle Clients und gibt sie dort als Nachricht aus
  function wuerfeln:integer;
  (* Gibt eine Zufallszahl zwischen 1 und 6 zurück. NICHT MEHR! *)
  procedure spieleranmelden(ip,name:string;port:Integer);
  // kreieren eines teilnehmenden Spielers
  procedure ziehen(augen:integer);
  (*Lässt den aktuellen Spieler unter Berücksichtigung von Los um augen Felder
    vorrücken. Nach Ankunft auf dem Feld wird die noch entsprechend reagiert*)
  procedure konten_ausgleichen;
  (* Prüft ob die Konten aller Spieler im Plus sind. Spieler dessen Konten im
     Negativen Bereich sind, müssen diese ausgleichen. Sollte immer als letzte
     Aktion einer Methode aufgerufen werden*)
  procedure Felderaktualisieren;
  (* Zählt nach, wie viele Bahnhöfe und Werke jeder Spieler besitzt,
     anschließend werden die Variablen dieser Aktualisiert*)
  procedure bauen(id:integer;aufbau:boolean);
  (* Baut auf dem Feld id. Bei aufbau werden Häuser gebaut bzw. eine Hypothek
     wird ausgelöst, bei aufbau=false werden Häuser abgebaut bzw. eine Hypothek
     aufgenommen. Vorraussetzung ist, das id eine Instanz von TBesitz ist und
     dem aktuellen Spieler gehört*)
  procedure nextspieler;
  //Der nächste Spieler ist an der Reihe, er wird zum Würfeln "aufgefordert"
  procedure akt_Gruppenbesitz;
  //Aktuakisiert Gruppenbesitz



  //Es folgen die Prozeduren die von außen aufgerufen werden
  procedure setserversocket(socket:Tserversocket);
  constructor create;
  destructor destroy;override;
  procedure spielstart;
  //startet Spiel(nachdem alle Spieler angemeldet sind)
  PROCEDURE einlesen (dateiname:String);
  //Lies das Spielbrett in der Datei mit dem Pfad Dateiname ein
  procedure setEreigniskarten(Karten:Array of TEreignis;Texte:Array of String;Anzahl:cardinal);
  (* Liest die Ereigniskarten ein. Anzahl gibt die Anzahl der Karten im Array
     an, hat bei 1 Karte den Wert 1 *)
  procedure Ereigniskartehinzufuegen(e:Tereignis;Text:string);
  //Fügt E dem Ereigniskartenstapel hinzu, Text ist der Text der Karte
  procedure setGemeinschaftskarten(Karten:Array of TEreignis;Texte:Array of String;Anzahl:cardinal);
  (* Liest die Gemeinschaftskarten ein. Anzahl gibt die Anzahl der Karten im
     Array an, hat bei 1 Karte den Wert 1 *)
  procedure Gemeinschaftskartehinzufuegen(e:Tereignis;Text:string);
  //Fügt E dem Gemeinschaftskartenstapel hinzu, Text ist der Text der Karte
  procedure setlosgeld(i:integer);
  (* Setzt den Betrag, den jeder Spieler bekommen soll, wenn er über Los kommt*)
  procedure setkaution(i:integer);
  (* Setzt die Kaution *)
  procedure gef_frei_karte_in_Ererignis;
  //Schiebt eine Gefängnis frei Karte in den Ereigniskarten stapel
  procedure gef_frei_karte_in_Gemeinschaft;
  //Schiebt eine Gefängnis frei Karte in den Ereigniskarten stapel
  procedure gef_frei_karte_reinschieben;
  (* Schiebt eine "Du kommst aus dem Gefängnis frei" Karte per Zufall in der
     Ereigniskartenstapel oder den Gemeinschaftskartenstapel *)



(*!!! Alle folgenden Methoden bitte nicht benutzen. Sie sind nur für den
  !!! internenGebrauch bestimmt*)
  procedure zuggef;
  //Spieler will würfeln um aus dem Gefängnis zu kommen
  procedure zug;
  procedure gefzahlen(karte:boolean);
  (* Spieler muss zahlen bzw. KArte einsetzen um rauszukommen(nach dem dritten
     mal würfeln *)
  procedure auf_Feld;
  procedure kaufen;
  procedure aktion;
  //Spieler kann danach interagieren(handeln, bauen etc.)
  procedure chan(Angebot:string);
  //aktueller Spieler macht ein Angebot
  procedure handelreaktion(antwort:boolean);
  (* Wird nach Reaktion des Mitspielers aufgerufen; teilt ablehnung mit bzw.
     vollzieht den Handel*)
// procedure aufgeben;
  (*Der aktuelle Spieler gibt auf *)
  procedure aufgeben(id:integer);

  //Netzwerkproceduren
(*Serveraction*)
  procedure name (n, ip : string; port : cardinal);
  procedure kauf(k:boolean);
  procedure hypo (SID : string);
  procedure baue (SID : cardinal; bau : boolean);
  procedure geza (e : string);
//e:string ??? wird nicht 1,2 oder 3 übergeben? oder ist es einfach mit nem string als mit nem cardinal(integer?)
  procedure wuer;
  procedure aufg (SID : string);
//mal wird Straßen-ID als string mal als cardinal übergeben; Selbiges bei Spieler-ID
  procedure hare (r : boolean);


  end;

(* Text für die "Du Kommst aus dem Gefängnis frei" Karte. Die Splittung erfolgte
   um zu verhinndern, dass der Quellcode zu breit wird. *)
const ft1='Du kommst aus dem Gefängnis Frei!'+#13+'Diese Karte bleibt in ';
const ft2='deinem Besitz,'+#13+'bis du sie einsetzt oder verkaufst.'+#13+'Nach';
const ft3=' Benutzung wird diese Karte zufällig in den Ereigniskartenstapel';
const ft4=#13+'oder den Gemeinschaftskartenstapel geschoben';
const frei_text=ft1+ft2+ft3+ft4;

procedure GefaengnisFrei_er(var spiel : tobject);
//Gefängnisfreikarte für Ereigniskartenstapel
procedure GefaengnisFrei_ge(var spiel : tobject);
//Gefängnisfreikarte für Gemeinschaftskartenstapel

implementation

procedure GefaengnisFrei_er(var spiel : tobject);
//Gefängnisfreikarte für Ereigniskartenstapel
var s:tmonopoly;
begin
  if spiel.ClassName='TMonopoly' then
  Begin
  s:=Tmonopoly(spiel);
  inc(s.Spieler[s.AktSpieler].AnzGefKarten);
  s.Ereignis.LetzteKarteHerausnehmen;
  end;
end;

procedure GefaengnisFrei_ge(var spiel : tobject);
//Gefängnisfreikarte für Gemeinschaftskartenstapel
var s:tmonopoly;
begin
  if spiel.ClassName='TMonopoly' then
  Begin
  s:=Tmonopoly(spiel);
  inc(s.Spieler[s.AktSpieler].AnzGefKarten);
  s.Gemeinschaft.LetzteKarteHerausnehmen;
  end;
end;

procedure tmonopoly.gef_frei_karte_reinschieben;
Begin
if random(2)=1 then self.gef_frei_karte_in_Ererignis
else self.gef_frei_karte_in_Gemeinschaft;
end;

procedure tmonopoly.gef_frei_karte_in_Ererignis;
var e:tereignis;
Begin
e:=GefaengnisFrei_er;
self.Ereigniskartehinzufuegen(e,frei_Text);
end;

procedure tmonopoly.gef_frei_karte_in_Gemeinschaft;
var e:tereignis;
Begin
e:=GefaengnisFrei_er;
self.Gemeinschaftskartehinzufuegen(e,frei_Text);
end;

procedure tmonopoly.hypo(sid:string);
var bes:tbesitz;
id:integer;
Begin
id:=strtoint(sid);
if (Felder[id].Typ=1) then
Begin
bes:=Tbesitz(Felder[id]);
bauen(id,bes.Zustand<0);
end;
end;

procedure tmonopoly.kauf(k:boolean);
Begin
if k then self.kaufen
else aktion;
end;

procedure tmonopoly.wuer;
Begin
self.zug;
end;

procedure tmonopoly.geza(e:string);
var eint:integer;
Begin
eint:=strtoint(e);
if (Spieler[aktspieler].AnzGefWuerfe<3) and (eint=2) then zuggef
else if not eint=2 then self.gefzahlen(eint=3)
else
Begin
netz.SendToClient(aktspieler,'mesg','Ungültige Aktion!'+'|');
netz.SendToClient(aktspieler,'gekg',booltostr(Spieler[aktspieler].AnzGefKarten>0)+'|');
end;
end;

procedure tmonopoly.name(n,ip:string;port:cardinal);
Begin
self.spieleranmelden(ip,n,port);
end;

procedure tmonopoly.baue(sid:cardinal;bau:boolean);
Begin
self.bauen(sid,bau);
end;

procedure tmonopoly.aufg(sid:string);
Begin
self.aufgeben(strtoint(sid));
end;

procedure tmonopoly.hare(r:boolean);
Begin
self.handelreaktion(r);
end;

procedure tmonopoly.akt_Gruppenbesitz;
var i,i2:integer;
gefunden,gefunden2:boolean;
strasse:tstrasse;
Verschieden:Array of tcolor;
gb:array of Farbenbesitz;
vl:integer;
//Anzahl der Elemente in Verschieden
  Gruppenbes_laenge:integer;
  //Länge des Arrays Gruppenbesitz, hat bei leeren Array den Wert -1
Begin
setlength(gruppenbesitz,maxstr);
setlength(gb,0);
gruppenbes_laenge:=-1;
vl:=-1;
for i:=1 to maxstr do
Begin
gefunden2:=false;
if (Felder[i].Typ=1) and (TBesitz(Felder[i]).Typ2=1) then
  Begin
  strasse:=tstrasse(Felder[i]);
  i2:=0;
  gefunden:=false;
  while (i2<=gruppenbes_laenge) and (gefunden=false) do
    Begin
    if gb[i2].farbe=strasse.farbe then
    Begin
    gefunden:=true;
    self.Gruppenbesitz[i]:=true;
    end;
    //Prüfen ob die aktuelle Strassenfarbe schon aufgenommen wurde
    end;
  i2:=0;
  while (i2<=vl) and (gefunden=false) do
    Begin
    if Verschieden[i2]=strasse.farbe then gefunden:=true;
    self.Gruppenbesitz[i]:=false;
    //Prüfen ob die aktuelle Strassenfarbe schon aufgenommen wurde
    end;
  if gefunden=false then
    Begin
      for i2:=1 to maxstr do if (Felder[i].Typ=1) and (TBesitz(Felder[i]).Typ2=1) and (Tstrasse(Felder[i2]).Farbe=strasse.Farbe) then
      Begin
       if (Tstrasse(Felder[i2]).Besitzer<>strasse.Besitzer) then gefunden2:=true;
      //Prüfen ob alle Strassen dieser Farbe im Besitz des gleichen Spielers sind
      end;
    if gefunden2=true then
      Begin
      inc(vl);
      setlength(verschieden,vl+1);
      verschieden[vl]:=strasse.farbe;
      //Aufnehmen in die Liste der Farben, bei denen nicht ein Spieler alle Strassen besitzt
      self.Gruppenbesitz[i]:=false;
      end
    else
     Begin
     inc(gruppenbes_laenge);
     setlength(gb,vl+1);
     gb[gruppenbes_laenge].Farbe:=strasse.farbe;
     gb[gruppenbes_laenge].Besitzer:=strasse.Besitzer;
     self.Gruppenbesitz[i]:=true;
     end;
    end;
  end;
end;
end;

procedure tmonopoly.set_Spieler_Geld(id,Geld:integer);
Begin
Spieler[id].Geld:=geld;
end;

procedure tmonopoly.set_Spieler_pos(id,Feld:integer);
Begin
if (feld>0) and (feld<=self.maxstr) then Spieler[id].Feld:=feld;
end;

procedure tmonopoly.ziehe_EReignisskarte;
var hk:tkarte;
Begin
hk:=Ereignis.KarteZiehen;
self.Nachricht_an_alle_spieler(hk.Text);
hk.Inhalt(tobject(self));
end;

procedure tmonopoly.zieheGemeinschaftskarte;
var hk:tkarte;
Begin
hk:=Gemeinschaft.KarteZiehen;
self.Nachricht_an_alle_spieler(hk.Text);
hk.Inhalt(tobject(self));
end;

procedure tmonopoly.akts_freiparken;
Begin
netz.SendToAllClients('geld',inttostr(self.Spieleranzahl)+'|');
end;

destructor tmonopoly.destroy;
var i:integer;
Begin
for i:=0 to maxstr-1 do
Begin
Felder[i].Destroy;
end;
for i:=0 to spieleranzahl-1 do
Begin
Spieler[i].Destroy;
end;
netz.SendToAllClients('mesg','Der Host hat das Spiel beendet.'+'|');
netz.SendToAllClients('ende',''+'|');
netz.Destroy;
if ang<>nil then ang.Destroy;
ereignis.Destroy;
gemeinschaft.Destroy;
end;

procedure tmonopoly.Gemeinschaftskartehinzufuegen(e:tereignis;text:string);
var hk:tkarte;
Begin
hk:=tkarte.create(e, text);
gemeinschaft.Hinzufuegen(hk);
end;

procedure tmonopoly.Ereigniskartehinzufuegen(e:tereignis;text:string);
var hk:tkarte;
Begin
hk:=tkarte.create(e, text);
Ereignis.Hinzufuegen(hk);
end;

procedure tmonopoly.setlosgeld(i:integer);
Begin
 if not spielgestartet then flosgeld:=i;
end;

procedure tmonopoly.setkaution(i:integer);
Begin
 if not spielgestartet then frei_geld:=i;
end;

procedure tmonopoly.setEreigniskarten(Karten:Array of TEreignis;Texte:Array of String;Anzahl:cardinal);
var i:integer;
Begin
for i:=0 to anzahl-1 do
Begin
self.Ereigniskartehinzufuegen(Karten[i],Texte[i]);
end;
end;

procedure tmonopoly.setGemeinschaftskarten(Karten:Array of TEreignis;Texte:Array of String;Anzahl:cardinal);
var i:integer;
Begin
for i:=0 to anzahl-1 do
Begin
self.Gemeinschaftskartehinzufuegen(Karten[i],Texte[i]);
end;
end;

procedure tmonopoly.aufgeben(id:integer);
var i,i2:integer;
player:tspieler;
NAchricht:string;
Begin
Nachricht:='Der Spieler '+Spieler[id].Name+' hat aufgegeben.'+#13+' Seine';
NAchricht:=Nachricht+' Besitztümer gehen zurück an die Bank';
netz.SendToAllClients('mesg',Nachricht+'|');
player:=Spieler[id];
for i:=0 to Spieler[id].BesitzAnzahl-1 do
Begin
Spieler[id].Besitz[i].Zustand:=0;
Spieler[id].Besitz[i].Besitzer:=-1;
end;
for i:=id to spieleranzahl-2 do
Begin
Spieler[i]:=Spieler[i+1];
for i2:=0 to SPieler[i].BesitzAnzahl-1 do dec(Spieler[i].besitz[i2].Besitzer);
end;
for i:=0 to player.AnzGefKarten do self.gef_frei_karte_reinschieben;
player.Destroy;
setlength(Spieler, spieleranzahl-1);
dec(spieleranzahl);
Netz.SendToAllClients('aufe',inttostr(id)+'|');
Kontoplus;//weiter gehts mit dem Prüfen, ob die Konten ausgeglichen sind.
end;

procedure tmonopoly.akts_Besitz(id:integer);
Begin
if Felder[id].Typ=1 then netz.SendToAllClients('besi',inttostr(id)+';'+inttostr(TBesitz(Felder[id]).Besitzer)+';'+inttostr(TBesitz(Felder[id]).Zustand)+'|');
end;

procedure tmonopoly.Felderaktualisieren;
var i:integer;
Begin
for i:=0 to spieleranzahl-1 do
Begin
Spieler[i].BahnhofAnzahl:=0;
Spieler[i].WerkAnzahl:=0;
//Initialisieren der Speicher
end;
for i:=0 to maxstr do
Begin
if Felder[i].Typ=1 then //Er prüft jedes Feld, ob es ein Besitz ist
Begin
  if Tbesitz(Felder[i]).Typ2>1 then //Er prüft jeden Besitz, ob es (Bahnhof oder Werk) ist
  Begin
  if Tbesitz(Felder[i]).Typ2=2 then inc(Spieler[Tbesitz(Felder[i]).Besitzer].BahnhofAnzahl);
   //Prüfung ob es ein Bahnhof ist+ inkrementierung des Bahnhofsspeichers des Besitzers
  if Tbesitz(Felder[i]).Typ2=3 then inc(Spieler[Tbesitz(Felder[i]).Besitzer].WerkAnzahl);
  //Prüfung ob es ein Werk ist+ inkrementierung des Werkspeichers des Besitzers
  end;
end;
end;
end;

procedure tmonopoly.Nachricht_an_alle_spieler(Text:string);
Begin
netz.sendtoallclients('mesg',Text+'|');
end;


PROCEDURE TMonopoly.einlesen (dateiname:String); //© Herr Nuck --> variiert yeah!
VAR f:TextFile; //die ganze Datei
    ds: String; //Puffer
    anzahl:integer;
begin
if spielgestartet=false then
begin
   AssignFile(f,dateiname);
   Reset(f);  //An Anfang der  Datei
   anzahl:=0; //Zeilennummer
   While NOT EOF(f) DO //EOF=EondOfFile
   begin
      ReadLN (f, ds);
      INC (anzahl);
      setlength(Felder,Anzahl);
//      liste[anzahl]:=TDatensatz.create;
//      liste[anzahl].einlesen(ds);
	  FeldEintragAuswerten(ds,anzahl); //Übergibt Zeile und Zeilennummer
   end;
   CloseFile(f)
end;
end;



PROCEDURE TMonopoly.FeldEintragAuswerten(zeile:String;ID:integer);
VAR
sempos : CARDINAL; //Position des Semikolons
Ersteintrag, nam : string;    //nam:Name
n,anz,pre,m1,m2,m3,m4,m5,m6,bau,hyp,Steu,Typ : integer; //fa:"Farbe"(gleiche Zahlen gehören zusammen), anz:Anzahl, pre:Preis , m1-m5 Mieten, bau:Baukosten, hyp:Hypothek
fa : tcolor;
begin
  sempos:=pos(';',zeile);
  Ersteintrag:=copy(zeile,1,sempos-1);
  delete(zeile,1,sempos);
  if Ersteintrag='st' then     //Straße
    begin
          sempos:=pos(';',zeile);
      id:=strtoint(copy(zeile,1,sempos-1));
          delete(zeile,1,sempos);
          sempos:=pos(';',zeile);
      fa:=stringtocolor(copy(zeile,1,sempos-1));
	  delete(zeile,1,sempos);
	  sempos:=pos(';',zeile);
      nam:=(copy(zeile,1,sempos-1));
	  delete(zeile,1,sempos);
	  sempos:=pos(';',zeile);
      pre:=strtoint(copy(zeile,1,sempos-1));
	  delete(zeile,1,sempos);
	  sempos:=pos(';',zeile);
      m1:=strtoint(copy(zeile,1,sempos-1)) ;
	  delete(zeile,1,sempos);
	  sempos:=pos(';',zeile);
      m2:=strtoint(copy(zeile,1,sempos-1));
	  delete(zeile,1,sempos);
	  sempos:=pos(';',zeile);
      m3:=strtoint(copy(zeile,1,sempos-1));
	  delete(zeile,1,sempos);
	  sempos:=pos(';',zeile);
      m4:=strtoint(copy(zeile,1,sempos-1));
	  delete(zeile,1,sempos);
	  sempos:=pos(';',zeile);
      m5:=strtoint(copy(zeile,1,sempos-1));
	  delete(zeile,1,sempos);
	  sempos:=pos(';',zeile);
      m6:=strtoint(copy(zeile,1,sempos-1));
	  delete(zeile,1,sempos);
	  sempos:=pos(';',zeile);
      bau:=strtoint(copy(zeile,1,sempos-1));
	  delete(zeile,1,sempos);
	  sempos:=pos(';',zeile);
      hyp:=strtoint(copy(zeile,1,sempos-1));
	  Felder[id]:=TFeld(TStrasse.create(self,id,fa,nam,pre,m1,m2,m3,m4,m5,m6,bau,hyp));
    end
    else
      if Ersteintrag='we' then   //Werke
      begin
          sempos:=pos(';',zeile);
        id:=strtoint(copy(zeile,1,sempos-1));
          delete(zeile,1,sempos);
          sempos:=pos(';',zeile);
        nam:=(copy(zeile,1,sempos-1));
	    delete(zeile,1,sempos);
	    sempos:=pos(';',zeile);
        pre:=strtoint(copy(zeile,1,sempos-1));
	    delete(zeile,1,sempos);
	    sempos:=pos(';',zeile);
        m1:=strtoint(copy(zeile,1,sempos-1));
	    delete(zeile,1,sempos);
	    sempos:=pos(';',zeile);
        m2:=strtoint(copy(zeile,1,sempos-1));
	    delete(zeile,1,sempos);
	    sempos:=pos(';',zeile);
        hyp:=strtoint(copy(zeile,1,sempos-1));
		Felder[id]:=TFeld(TWerk.create(self,id,nam,pre,m1,m2,hyp));
      end
      else
        if Ersteintrag='ba' then //Bahnhof
        begin
              sempos:=pos(';',zeile);
          id:=strtoint(copy(zeile,1,sempos-1));
              delete(zeile,1,sempos);
              sempos:=pos(';',zeile);
          nam:=(copy(zeile,1,sempos-1));
	      delete(zeile,1,sempos);
	      sempos:=pos(';',zeile);
          pre:=strtoint(copy(zeile,1,sempos-1));
	      delete(zeile,1,sempos);
	      sempos:=pos(';',zeile);
          m1:=strtoint(copy(zeile,1,sempos-1));
	      delete(zeile,1,sempos);
	      sempos:=pos(';',zeile);
          m2:=strtoint(copy(zeile,1,sempos-1));
	      delete(zeile,1,sempos);
	      sempos:=pos(';',zeile);
          m3:=strtoint(copy(zeile,1,sempos-1));
	      delete(zeile,1,sempos);
	      sempos:=pos(';',zeile);
          m4:=strtoint(copy(zeile,1,sempos-1));
	      delete(zeile,1,sempos);
	      sempos:=pos(';',zeile);
          hyp:=strtoint(copy(zeile,1,sempos-1));
		  Felder[id]:=TFeld(TBahnhof.create(self,id,nam,pre,m1,m2,m3,m4,hyp));
        end
        else
          if Ersteintrag='ec' then  //Ecke
          begin
	         sempos:=pos(';',zeile);
             id:=strtoint(copy(zeile,1,sempos-1));
	         delete(zeile,1,sempos);
	         sempos:=pos(';',zeile);
             nam:=(copy(zeile,1,sempos-1));
	         delete(zeile,1,sempos);
	         sempos:=pos(';',zeile);
             typ:=strtoint(copy(zeile,1,sempos-1));
			 Felder[id]:=TFeld(TEcke.create(self,id,nam,Typ));
			 if id=0 then los:=0; //Los
			 if typ=1 then gef:=id; //Gefängnis
			 if typ=2 then frei:=id; //Frei Parken
			 if typ=3 then gehgef:=id; //Gehe ins Gefängnis
          end
          else
            if Ersteintrag='steu' then  //Steuerfeld
            begin
	         sempos:=pos(';',zeile);
             id:=strtoint(copy(zeile,1,sempos-1));
	         delete(zeile,1,sempos);
	         sempos:=pos(';',zeile);
             nam:=(copy(zeile,1,sempos-1));
	         delete(zeile,1,sempos);
	         sempos:=pos(';',zeile);
             steu:=strtoint(copy(zeile,1,sempos-1));
			 Felder[id]:=TFeld(TSteuerfeld.create(self,id,nam,steu));
            end
            else  //Sonderfeld (Ereignisfeld,Gemeinschaftsfeld)
              begin
	            sempos:=pos(';',zeile);
                id:=strtoint(copy(zeile,1,sempos-1));
	            delete(zeile,1,sempos);
	            sempos:=pos(';',zeile);
                nam:=(copy(zeile,1,sempos-1));
	            delete(zeile,1,sempos);
	            sempos:=pos(';',zeile);
                typ:=strtoint(copy(zeile,1,sempos-1));
				Felder[id]:=TFeld(Tsonderfeld.create(self,id,nam,Typ));
				if Typ=0 then Tsonderfeld(Felder[id]).warteschlange:=Ereignis;
				if Typ=1 then Tsonderfeld(Felder[id]).warteschlange:=Gemeinschaft;
              end;
end;

constructor tmonopoly.create;
Begin
Spieleranzahl:=0;
spielgestartet:=false;
Ereignis:=twarteschlange.Create;
Gemeinschaft:=twarteschlange.Create;
self.echtaktspieler:=-1;
end;

function TMonopoly.wuerfeln:integer;
Begin
   result:=random(6)+1;
end;


{
procedure TMonopoly.aufgeben; //Magiesucht, Colipedia
Var Besitz: TBesitz;
    strasse:Tstrasse;
    looser:Tspieler; //Aufgebender
begin
   looser:=spieler[aktspieler];
   looser.Aufgegeben:=true;
   repeat
   begin
   Besitz:=Tbesitz(looser.besitz[looser.BesitzAnzahl-1]); //Zugriff auf den vorletzten Eintrag im Spielerbesitz  (da wegen TMonopoly.kaufen letzter Eintrag leer und letzter Eintrag leer ist... FRAG NICHT WIESO!!)
   Besitz.Besitzer:=-1; // Feldeigenschaft Besitz wird frei
   if besitz.typ2=1 then //Wenn es "Straße" (und nicht Werk/Bahnhof) ist
   begin
      Strasse := Tstrasse(Besitz);
      Strasse.Zustand:=0; //Zustand der Straße auf 0 (ohne Bebauung) gestellt
   end;
   DEC(looser.besitzanzahl); //Besitz(anzahl) veringert
   end;
   until looser.besitzanzahl=0;
   nextspieler;
end;    }


procedure tmonopoly.setserversocket(socket:tserversocket);
Begin
netz:=tserver.create(socket);
end;

procedure TMonopoly.spieleranmelden(ip,name:string;port:Integer);
var i:integer;
Begin
        if not Spielgestartet then
        Begin
        netz.SendToAllClients('spin',inttostr(spieleranzahl)+';'+inttostr(spieleranzahl)+';'+name+'|');
        setlength(Spieler,Spieleranzahl+1);
        Spieler[Spieleranzahl]:=Tspieler.create(self,(spieleranzahl),ip,name,port,maxstr);
        for i:=0 to spieleranzahl-1 do netz.SendToClient(spieleranzahl,'spin',inttostr(self.Spieleranzahl)+';'+inttostr(i)+';'+Spieler[i].Name+'|');
        inc(Spieleranzahl);
        end;
end;

procedure tmonopoly.spielstart;
var
i:integer;
Begin
 Spielgestartet:=true;

 for i:=0 to spieleranzahl-1 do
 Begin
 spieler[i].Geld:=Startgeld;
 netz.SendToClient(i,'spid',inttostr(i)+'|');
 end;
aktspieler:=-1;
netz.sendtoallclients('star',''+'|');
self.nextspieler;
end;

procedure TMonopoly.nextspieler;
begin
pasch:=0;
aktspieler:=(aktspieler+1) mod spieleranzahl;
IF NOT Spieler[aktspieler].Gefangen THEN netz.SendToClient(aktspieler,'btnc',''+'|')
ELSE netz.SendToClient(aktspieler,'gefg',BoolToStr(Spieler[aktspieler].AnzGefKarten>0)+'|');



end;

procedure TMonopoly.gefzahlen(karte:boolean);
BEGIN
   IF (karte) AND(Spieler[aktspieler].AnzGefKarten>0) THEN
   BEGIN
      DEC(Spieler[aktspieler].AnzGefKarten);
      Spieler[aktspieler].gefangen:=false;
      self.gef_frei_karte_reinschieben;
   end
   ELSE IF (NOT karte) AND (Spieler[aktspieler].geld>preis_freikauf) THEN
   BEGIN
      Spieler[aktspieler].geld:=Spieler[aktspieler].geld-preis_freikauf;
      Spieler[aktspieler].gefangen:=false;
   END;
   if not Spieler[aktspieler].gefangen then zug
   else
   Begin
   netz.Sendtoclient(aktspieler,'mesg','Ungültige Aktion'+'|');
   netz.SendToClient(aktspieler,'gefg',BooltoStr(Spieler[aktspieler].AnzGefKarten>0)+'|')
   end;
END;



procedure TMonopoly.zug;
var a1,a2:integer;
Begin
a1:=wuerfeln;
a2:=wuerfeln;
Augenzahl:=a1+a2;
IF a1=a2 THEN INC(pasch)
Else pasch:=0;
netz.SendToAllClients('wurf',inttostr(a1)+';'+inttostr(a2)+'|');//Mitteilung des würfelergebnisses
IF pasch=3 Then
  begin
  netz.SendToAllClients('mesg','Dritter Pasch, der Spieler '+Spieler[aktspieler].Name+' wurde eingesperrt!'+'|');
  netz.SendToAllClients('gefa',inttostr(aktspieler)+';'+Booltostr(true)+'|');
   Spieler[aktspieler].Feld:=gef;
   Spieler[aktspieler].Gefangen:=true;
   Pasch:=0;
   self.aktion;//Mitteilung an Client dass er Handeln kann
  end
ELSE
Begin
ziehen(a1+a2);
end;
end;

procedure TMonopoly.zuggef;
var  a1,a2: integer;
Begin

           a1:=wuerfeln;
           a2:=wuerfeln;
           Augenzahl:=a1+a2;
           INC(Spieler[aktspieler].anzgefwuerfe);
           IF a1=a2 THEN
           Begin
             Spieler[aktspieler].gefangen:=false;
             ziehen(a1+a2); // zug
           end
           else if Spieler[aktspieler].anzgefwuerfe>2 then netz.SendToClient(aktspieler,'gekg',''+'|');
end;

procedure TMonopoly.auf_Feld;
VAR  Besitz:TBesitz;
     Steuer:TSteuerfeld;
     karte:tkarte;
miete:integer;
Ecke:Tecke;
BEGIN
CASE Felder[Spieler[aktspieler].Feld].typ  of
1: BEGIN
Besitz:=TBesitz(Felder[Spieler[aktspieler].Feld]);
IF Besitz.Besitzer<0 THEN netz.SendToClient(aktspieler,'hndl',''+'|')
ELSE IF Besitz.Besitzer<>aktspieler THEN
Begin
  Miete:=Besitz.getmiete(augenzahl);
  netz.SendtoallClients('mesg',Spieler[aktspieler].name+' muss '+inttostr(Miete)+' an '+Spieler[Tbesitz(Felder[Spieler[aktspieler].Feld]).besitzer].Name+' zahlen.'+'|');
  Spieler[Besitz.Besitzer].geld:=Spieler[Besitz.Besitzer].geld+miete;
  Spieler[aktspieler].geld:=Spieler[aktspieler].geld-miete;
END;
END;
2: BEGIN
Steuer:=TSTeuerFeld(Felder[Spieler[aktspieler].Feld]);
INC(frei_Parken,Steuer.Steuer);
self.akts_freiparken;
Spieler[aktspieler].geld:=Spieler[aktspieler].Geld-steuer.steuer;
END;
3:
  Begin
Karte:=TSonderfeld(Felder[Spieler[aktspieler].Feld]).warteschlange.karteziehen;
netz.SendToAllClients('mesg',karte.Text+'|');
Karte.Inhalt(Tobject(self));
//Zieht oberste Karte
end;
4:
Begin
Ecke:=Tecke(Felder[Spieler[aktspieler].Feld]);
if ecke.Eckentyp=0 then Spieler[aktspieler].Geld:=Spieler[aktspieler].Geld+losgeld
else if ecke.Eckentyp=2 then
  Begin
  Spieler[aktspieler].Geld:=Spieler[aktspieler].Geld+frei_parken;
  frei_parken:=0;
  self.akts_freiparken;
  end
else if ecke.Eckentyp=3 then
  Begin
  netz.SendToAllClients('gefa',inttostr(aktspieler)+';'+Booltostr(true)+'|');
  Spieler[aktspieler].Feld:=gef;
  Spieler[aktspieler].Gefangen:=true;
  Pasch:=0;
  end;
end;
END;
self.konten_ausgleichen;
END;


procedure TMonopoly.ziehen(augen:integer);
var i:integer;
Begin
if Spieler[aktspieler].Feld+augen>maxstr then Spieler[aktspieler].Geld:=Spieler[aktspieler].Geld+self.losgeld;
Spieler[aktspieler].Ziehen(augen);
end;

procedure TMonopoly.kaufen;
Var Besitz: TBesitz;
BEGIN
IF Felder[Spieler[aktspieler].Feld].typ=1 THEN
Begin
Besitz:=Tbesitz(Felder[Spieler[aktspieler].Feld]);
  IF besitz.Besitzer<0 THEN
  BEGIN
  IF Spieler[aktspieler].geld>=Besitz.preis THEN
  BEGIN
    Besitz.Zustand:=0;
    Besitz.Besitzer:=aktspieler;
    INC(Spieler[aktspieler].besitzanzahl);
    Spieler[aktspieler].besitz[SPieler[aktspieler].BesitzAnzahl-1]:=besitz;
    Spieler[aktspieler].geld:=Spieler[aktspieler].geld-besitz.Preis;
    netz.SendToAllClients('besi',inttostr(besitz.ID)+';'+inttostr(aktspieler)+';0'+'|');
  END;
  END;
self.konten_ausgleichen;
END;
END;

procedure TMonopoly.chan(Angebot:string);
BEGIN
ang:=tangebot.create(angebot);
netz.SendToClient(ang.sempf,'shan',angebot+'|');
END;


procedure Tmonopoly.bauen(id:integer;aufbau:boolean);
var i:integer;// Id im Felder Array
    all:boolean;
    besitz:Tbesitz;
    strasse:Tstrasse;
BEGIN
Besitz:=nil;
all:=true; //true bedeutet er hat alle
for i:=0 to maxstr do
Begin
if Felder[i].typ=1 then
Begin
Besitz:=Tbesitz(Felder[i]);
if (Besitz.Typ2=1) and (Besitz.Besitzer<>aktspieler) then
  Begin
  if TStrasse(Spieler[aktspieler].Besitz[id]).Farbe=TStrasse(Besitz).Farbe then all:=false;
  end;
end;
end;
Strasse:=TStrasse(Spieler[aktspieler].Besitz[id]);
if (all) then
Begin
if aufbau then
  Begin
  if (Strasse.Zustand<5) and (Spieler[aktSpieler].Geld>=Strasse.Baukosten) then
    Begin
    Spieler[aktspieler].geld:=Spieler[aktspieler].geld-strasse.Baukosten;
   inc(Strasse.Zustand);
   end;
  end;
end
else
  Begin
  if not aufbau then
    Begin
    if (Strasse.Zustand>0) then
      Begin
      Spieler[aktSpieler].Geld:=Spieler[aktSpieler].Geld-strasse.Baukosten;
      dec(Strasse.Zustand);
      end;
    if Strasse.Zustand=0 then
      Begin
      Spieler[aktSpieler].Geld:=Spieler[aktSpieler].Geld+strasse.Hypothek;
      dec(Strasse.Zustand);
      end;
    end;
  end;
if (besitz<>nil) then netz.SendToallclients('besi',inttostr(Besitz.id)+';'+inttostr(besitz.Besitzer)+inttostr(besitz.Zustand)+'|');
self.konten_ausgleichen;
END;

procedure Tmonopoly.handelreaktion(antwort:boolean);
VAR i:integer;
var send,empf:Tspieler;
bes:tbesitz;
procedure raus(id,max:integer;ar:Array of tBesitz);
var ind,i2:integer;//id:Feld id der zu entfernenden Straße
//ind Position im Besitzarray des Spielers der Straße
//i2 Schleifenvariable
Begin
for i2:=0 to max do
Begin
if ar[i2].ID=id then ind:=i2;
end;
for ind:=ind to max do
Begin
if ind<max then ar[ind]:=ar[ind+1]
else ar[ind]:=nil;
end;
end;
BEGIN
IF antwort and (ang<>nil) THEN
BEGIN
Spieler[ang.sempf].geld:=Spieler[ang.sempf].geld+ang.geld;
Spieler[ang.ssender].geld:=Spieler[ang.ssender].geld-ang.geld;
Spieler[ang.sempf].AnzGefKarten:=Spieler[ang.sempf].AnzGefKarten+ang.GefKarten;
Spieler[ang.ssender].AnzGefKarten:=Spieler[ang.ssender].AnzGefKarten-ang.GefKarten;
send:=Spieler[ang.ssender];
empf:=Spieler[ang.sempf];
For i:=0 to ang.anzG-1 DO
BEGIN
raus(ang.Strassengeben[i],send.BesitzAnzahl,send.Besitz);
bes:=TBesitz(Felder[ang.Strassengeben[i]]);
empf.Besitz[empf.BesitzAnzahl]:=bes;
netz.SendToAllClients('besi',inttostR(bes.ID)+';'+inttostr(bes.Besitzer)+';'+inttostr(bes.Zustand)+'|');
inc(empf.BesitzAnzahl);
dec(send.BesitzAnzahl);
END;
For i:=0 to ang.anzN-1 DO
BEGIN
raus(ang.Strassennehmen[i],empf.BesitzAnzahl,empf.Besitz);
bes:=TBesitz(Felder[ang.Strassengeben[i]]);
send.Besitz[send.BesitzAnzahl]:=bes;
netz.SendToAllClients('besi',inttostR(bes.ID)+';'+inttostr(bes.Besitzer)+';'+inttostr(bes.Zustand)+'|');
inc(send.BesitzAnzahl);
dec(empf.BesitzAnzahl);
END;
ang.Destroy;
ang:=nil;
END else if ang<>nil then netz.SendToClient(ang.ssender,'hars',booltostR(false)+'|');
self.konten_ausgleichen;
END;


procedure tMonopoly.aktion;
Begin
netz.sendtoclient(aktspieler,'fhnd',''+'|');
end;

procedure tmonopoly.konten_ausgleichen;
Begin
nach_kp:=1;
self.kontoplus;
end;

procedure Tmonopoly.Kontoplus;
var i:integer;
gef:boolean;//zeigt ob jemand gefunden wurde
Begin
if echtaktspieler<0 then
Begin
echtaktspieler:=aktspieler;
i:=0;
end
else i:=aktspieler;
gef:=false;
while (not gef) and (i<spieleranzahl) do
Begin
if Spieler[i].geld<0 then gef:=true;
inc(i);
end;
if not gef then 
Begin
aktspieler:=echtaktspieler;
echtaktspieler:=-1;
if nach_kp=1 then self.aktion;
nach_kp:=0;
end
else
Begin
aktspieler:=i-1;
netz.sendtoclient(aktspieler,'koau',''+'|');
end;
end;

end.

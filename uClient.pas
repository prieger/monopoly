unit uclient;
 interface
USES Ufeld,uKommunikation, Graphics,ScktComp,SysUtils,uangebot,uVirtualAnimation;


type tclientsp=class
public
  Server_aktiv:boolean;
  Felder : array of TFeld; //Los hat den Index 0
  maxstr:integer;//gibt Länge vom Felderarray an; hat bei leerem Spielfeld einen negativen Wert
  Spieleranzahl : integer;
  serverport:integer;
  serverip:string;
  gui:TVirtualAnimation;
  Spieler: array of Tspielerdaten;
  Gef:integer;
  los:integer;
  gehgef:integer;
  frei:integer;
  frei_parken: Integer; // Geld in der Mitte
  netz:tclient;
  id:integer; //Welche id hat der Spieler dieses Clients

constructor create(var vgui:TVirtualAnimation);
destructor destroy; override;
procedure setclientsocket(socket:tclientsocket);

procedure kaufwunsch(kaufen:boolean);
(* Spieler möchte Straße kaufen, auf der er aktuell ist, wenn kaufen wahr ist,
   wenn nicht muss es false sein *)

PROCEDURE einlesen (dateiname:String);
//Liest die Straßen in der Datei dateiname ein

procedure hypothek (id:integer);
(* Spieler möchte Hypothek aufnehmen;id ist die id der Straße auf dem Brett.
Wenn schon eine Hypothek drauf ist, dann wird sie ausgelöst *)

procedure baue(id:integer;aufbau:boolean);(*Spieler möchte auf einer Straße
bauen, id ist die id der Straße auf dem Brett,aufbau gibt an, ob der Spieler
häuser/Hotels bauen oder abreißen möchte  *)

procedure gefaengnishandlung(handlung:integer);(*Spieler gibt an ober er
1. zahlen möchte, 2. würfeln möchte oder3. eine Du kommst aus dem Gefängnis
 frei karte benutzt*)

procedure fertig;
//Spieler beendet seinen Zug

procedure wuefeln;(*Spieler möchte würfeln (bei zugbeginn, wenn er nicht im
Gefängnis ist)  *)

procedure set_server_ip(i:string);
//Setzt die server ip

procedure anserveranmelden(name:string);
(*meldet diesen client an den Server an.Name ist der Name den der Spieler
dieses Clients benutzen will.
*)
procedure aufgabe;
(*Meldet dem Server, dass dieser Spieler aufgeben möchte.*)

procedure spielerinfo(anzahl,id:integer; name:string);
(* Fügt dem Spieler Array bei bedarf die nötige Anzahl an Spielern hinzu.
   Außerdem wírd der Name bei dem Spieler id eingetragen *)

procedure ziehen(id,anzahl:integer);

procedure will_handeln(a:tangebot);
(* Der Spieler dieses Clients macht das Angebot a*)

// Prozeduren, die aus dem Netzwerk aufgerufen werden
  procedure wurf(wrfl1, wrfl2 : cardinal);
  procedure spos(pos, SID : cardinal);
  procedure gefa(SID : cardinal; gefangen : boolean);
  procedure geld(SID, geld : cardinal);
  procedure besi(FID, SID, zustand : cardinal);
  procedure szug(SID,anz : integer);
  procedure gefg(e : boolean);
  procedure hndl;
  procedure btnc;
  procedure koau;
  procedure kost(SID, geld : cardinal);
  procedure fhnd;
  procedure gekg(k : boolean);
  procedure spid(SID : string);
  procedure hars(r : boolean);
  procedure aufe(id:integer);
  procedure spin(gesamtzahl,spielerid:integer;spielername:string);
  procedure ende;
  procedure shan(s:string);
  procedure star;

private
PROCEDURE FeldEintragAuswerten(zeile:String;ID:integer);
end;



implementation

procedure tclientsp.star;
Begin
self.gui.Start;
end;

procedure tclientsp.will_handeln(a:tangebot);
Begin
netz.SendToServer('chan',a.toString);
end;

procedure tclientsp.shan(s:string);
Begin
gui.Handelsvorschlag(tangebot.create(s));
end;


procedure tclientsp.ziehen(id,anzahl:integer);
Begin
Spieler[id].Feld:=Spieler[id].Feld+anzahl;
gui.setSpielerPos(id);
end;


destructor tclientsp.destroy;
var i,i2:integer;
Begin
for i:=0 to maxstr-1 do
Begin
Felder[i].Destroy;
end;
for i:=0 to spieleranzahl-1 do
Begin
Spieler[i].Destroy;
end;
if self.Server_aktiv then netz.SendToServer('aufg','');
netz.Destroy;
end;


procedure tclientsp.setclientsocket(socket:tclientsocket);
Begin
netz:=tclient.create(socket);
end;

constructor tclientsp.create(var vgui:TVirtualAnimation);
Begin
server_aktiv:=true;
gui:=vgui;
einlesen(gui.strassen);
frei_parken:=0;
serverip:='127.0.0.1';
serverport:=2000;
end;

procedure tclientsp.ende;
Begin
server_aktiv:=false;
gui.ende;
end;

procedure tclientsp.kaufwunsch(kaufen:boolean);
Begin
netz.SendToServer('kauf',booltostr(kaufen));
end;

procedure tclientsp.hypothek(id:integer);
var i,idbesitz:integer;
Begin
idbesitz:=-1;
for i:=0 to Spieler[id].BesitzAnzahl-1 do if Spieler[id].Besitz[i].ID=id then idbesitz:=Spieler[id].Besitz[i].ID;
if id>-1 then netz.SendToServer('hypo',inttostr(idbesitz));
end;

procedure tclientsp.baue(id:integer;aufbau:boolean);
var i,idbesitz:integer;
Begin
idbesitz:=-1;
for i:=0 to Spieler[id].BesitzAnzahl-1 do if Spieler[id].Besitz[i].ID=id then idbesitz:=Spieler[id].Besitz[i].ID;
if id>-1 then netz.SendToServer('baue',inttostr(idbesitz)+'|'+booltostr(aufbau));
end;

procedure tclientsp.gefaengnishandlung(handlung:integer);
Begin
netz.SendToServer('geza',inttostr(handlung));
end;

procedure tclientsp.fertig;
Begin
netz.SendToServer('zuge','');
end;

procedure tclientsp.wuefeln;
Begin
netz.SendToServer('wuer','');
end;

procedure tclientsp.set_server_ip(i:string);
Begin
serverip:=i;
netz.SetIp(i);
end;

procedure tclientsp.anserveranmelden(name:string);
Begin
netz.SendToServer('Name',name);
end;

procedure tclientsp.aufe(id:integer);
var i:integer;
player:Tspielerdaten;
Begin
gui.Aufgeben(id);
player:=Spieler[id];
for i:=0 to Spieler[id].BesitzAnzahl-1 do
Begin
Spieler[id].Besitz[i].Zustand:=0;
Spieler[id].Besitz[i].Besitzer:=-1;
end;
for i:=id to spieleranzahl-2 do Spieler[i]:=Spieler[i+1];
player.Destroy;
setlength(Spieler, spieleranzahl-1);
dec(spieleranzahl);
end;

procedure tclientsp.spin(gesamtzahl,spielerid:integer;spielername:string);
Begin
if spielerid>=spieleranzahl then
Begin
setlength(spieler,spielerid+1);
end;
if spieler[spielerid]=nil then spieler[spielerid]:=tspielerdaten.create(id,'',spielername,1337,maxstr)
else
Begin
spieler[spielerid].Name:=spielername;
end;
self.Spieleranzahl:=gesamtzahl;
end;

procedure tclientsp.aufgabe;
Begin
netz.SendToServer('aufg',inttostr(self.id));
end;

procedure tclientsp.spielerinfo(anzahl,id:integer; name:string);
Begin
if anzahl<spieleranzahl then
Begin
setlength(Spieler,anzahl);
spieleranzahl:=anzahl;
end;
Spieler[id]:=tspielerdaten.create(id,'',name,0,maxstr);
end;


procedure tclientsp.wurf(wrfl1, wrfl2 : cardinal);
begin
// [GUI] Anzeige der Wurfergenbisse.
gui.wuerfel(wrfl1,wrfl2);
end;

procedure tclientsp.spos(pos, SID : cardinal);
begin
// [GUI] Anzeige der Spielerposition.
Spieler[sid].feld:=pos;
gui.setSpielerPos(sid);
end;

procedure tclientsp.gefa(SID : cardinal; gefangen : boolean);
begin
// [GUI] Anzeige des Zustandes des Spielers ob gefangen oder frei........
Spieler[sid].gefangen:=gefangen;
gui.setSpielerPos(sid);
end;

procedure tclientsp.geld(SID, geld : cardinal);
begin
Spieler[id].geld:=geld;
gui.aktualisieren;
// [GUI] Anzeige des Geldstandes.
end;

procedure tclientsp.besi(FID, SID, zustand : cardinal);
begin
TBesitz(Felder[Fid]).besitzer:=sid;
Tbesitz(Felder[fid]).zustand:=zustand;
gui.aktualisieren;
// [GUI] Anzeige des Besitzers des Feldes.
end;

procedure tclientsp.szug(SID,anz : integer);
begin
// [GUI] Anzeige des aktuellen Spielers
gui.setSpielerPos(sid);
end;


procedure tclientsp.gefg(e : boolean);
begin
// [GUI] Anzeige der Wahlmöglichkeiten
gui.gefaegniswahl(e);
end;

procedure tclientsp.hndl;
Begin
gui.kaufen;
end;

procedure tclientsp.btnc;
begin
//[GUI] Würfelbutton verfügbar machen. Client mitteilen, dass er würfeln soll/kann/darf/muss
gui.bitte_Wuerfeln;
end;

procedure tclientsp.koau;
Begin
gui.Kontoausgleichen;
end;

procedure tclientsp.kost(SID, geld : cardinal);
begin
//[GUI] Anzeige aktualiesieren der SID und zugehörigem Gelstand.
if sid<self.Spieleranzahl then
//Wenn sid=Spieleranzahl, dann wurde der Frei-Parken betrag übermittelt
Begin
Spieler[sid].Geld:=geld;
gui.aktualisieren;
end
else
Begin
self.frei_parken:=geld;
gui.freiparkengeld_akt;
end;
end;

procedure tclientsp.fhnd;
begin
gui.freihandeln;
end;

procedure tclientsp.gekg(k : boolean);
begin
gui.gefaengnis3(k);
end;

procedure tclientsp.spid(SID : string);
begin
id:=strtoint(sid);
Spieler[id].ID:=id;
end;

procedure tclientsp.hars(r : boolean);
begin
gui.Spielerreaktion(r);
end;

PROCEDURE tclientsp.einlesen (dateiname:String); //© Herr Nuck --> variiert yeah!
VAR f:TextFile; //die ganze Datei
    ds: String; //Puffer
    anzahl:integer;
begin

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



PROCEDURE tclientsp.FeldEintragAuswerten(zeile:String;ID:integer);
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
				end;
end;



end.

unit uguivirtuell;

interface
uses uangebot;
type tvirtuellgui=class
procedure wuerfel(wurf1,wurf2:integer); virtual; abstract;
//Auschließliches Ausgeben der Würfelergebnisse (nicht mehr!)
Procedure geldakt(id:integer); virtual; abstract;
//Geldanzeige des Spielers mit dem Index id soll aktualisiert werden
procedure spielerposi(id:integer); virtual;abstract;
(* Position des Spielers mit dem Index id soll aktualisiert werden; ohne
   Animation; der Spieler soll "teleportiert" werden *)
procedure besitzakt(id:integer); virtual; abstract;
//Feld mit dem Index id soll aktualisiert werden
procedure gefaegniswahl(Kartenerlaubt:boolean); virtual; abstract;
(*Spieler soll Entscheiden, was er tun will um aus dem Gefängnis zu entkommen
Kartenerlaubt gibt an, ob er eine "Du kommst aus dem Gefängnisfrei" Karte
einsetzen darf*)
procedure kaufen; virtual; abstract;
//Spieler soll entscheiden, ob er die aktuelle Straße von der Bank kaufen möchte
procedure Nachricht(Text:String);  virtual; abstract;
//Der String Text soll als Nachricht ausgegeben werden
procedure freihandeln;       virtual; abstract;
(*Spieler soll Möglichkeit bekommen ob er die Grundstücke verwalten will,
Handeln oder seinen Zug beenden möchte*)
procedure gefaengnis(Kartenerlaubt:boolean); virtual; abstract;
(*Spieler soll Entscheiden, was er tun will um aus dem Gefängnis zu entkommen.
Er kann nicht mehr würfeln!
Kartenerlaubt gibt an, ob er eine "Du kommst aus dem Gefängnisfrei" Karte
einsetzen darf*)
procedure Kontoausgleichen; virtual; abstract;
(*Spieler soll Konto ausgleichen. Dafür brauch er die Optionen zum Verwalten der
Grundstücke, zum Handeln und aufgeben*)
{procedure Handelabgelehnt; virtual; abstract;
(*Der Handel, den der Spieler dieser Instanz vorgeschlagen hat, wurde abgelehnt.
Dies sollte dem Spieler mitgeteilt werden bzw. die Anzeige, dass der andere noch
Überlegt sollte verschwinden*)  }
Procedure Handelsvorschlag(a:tangebot); virtual; abstract;
(* Dem Spieler wird der Handel a vorgeschlagen.*)
procedure Spielerreaktion(angenommen:boolean);  virtual; abstract;
(* Die Reaktion des Mitspielers auf den Handel, bei wahr wurde er angenommen.
Es muss lediglich die Reaktion dem Spieler mitgeteilt werden, nicht mehr! *)
procedure Aufgegeben(id:integer); virtual; abstract;
(* Der Spieler id hat aufgegeben, dies sollte gekennzeichnet werden.*)
function strassen:String; Virtual; abstract;
(*Spieler soll die Datei mit den Strassen auswählen welche verwendet werden
 soll. Die Funktion soll den Pfad zur ausgewählten Datei zurückgeben. Wird nur
 im Constructor von Tclientsp benutzt.*)
procedure Bitte_Wuerfeln; virtual; abstract;
//Spieler soll Möglichkeit zum Würfeln erhalten
procedure freiparkengeld_akt; virtual; abstract;
(*Es soll das Frei Parken Geld (Variable: Frei_parken) aktualisiert werden *)
procedure ende; virtual; abstract;
(* Der Server hat das Spiel beendet. Der Spieler darf nur noch Aktionen
   ausführen, welche lokal begrenzt sind (also keinen Netzwerkverkehr mehr
   auslösen*)
procedure ziehen(id,anzahl:integer); virtual; abstract;
(* Der Spieler Id soll anzahl Felder ziehen. Wenn Anzahl negativ ist, soll
   der Spieler Rückwärts ziehen *)

 end;

(*Idee für einbindung: Ihr macht eine von tvirtuellgui abgeleitete Klasse,
in der die Methoden implementiert sind. Anschließend setzt ihr in der Instanz
von Tclient den Zeiger gui auf eine Instanz von dieser abgeleiteten Klasse.
Ist Jedoch nur eine Idee/ein Vorschlag.
*)

implementation

end.

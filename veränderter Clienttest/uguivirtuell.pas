unit uguivirtuell;

interface
uses uangebot;
type tvirtuellgui=class
procedure wuerfel(wurf1,wurf2:integer); virtual; abstract;
//Auschlie�liches Ausgeben der W�rfelergebnisse (nicht mehr!)
Procedure geldakt(id:integer); virtual; abstract;
//Geldanzeige des Spielers mit dem Index id soll aktualisiert werden
procedure spielerposi(id:integer); virtual;abstract;
(* Position des Spielers mit dem Index id soll aktualisiert werden; ohne
   Animation; der Spieler soll "teleportiert" werden *)
procedure besitzakt(id:integer); virtual; abstract;
//Feld mit dem Index id soll aktualisiert werden
procedure gefaegniswahl(Kartenerlaubt:boolean); virtual; abstract;
(*Spieler soll Entscheiden, was er tun will um aus dem Gef�ngnis zu entkommen
Kartenerlaubt gibt an, ob er eine "Du kommst aus dem Gef�ngnisfrei" Karte
einsetzen darf*)
procedure kaufen; virtual; abstract;
//Spieler soll entscheiden, ob er die aktuelle Stra�e von der Bank kaufen m�chte
procedure Nachricht(Text:String);  virtual; abstract;
//Der String Text soll als Nachricht ausgegeben werden
procedure freihandeln;       virtual; abstract;
(*Spieler soll M�glichkeit bekommen ob er die Grundst�cke verwalten will,
Handeln oder seinen Zug beenden m�chte*)
procedure gefaengnis(Kartenerlaubt:boolean); virtual; abstract;
(*Spieler soll Entscheiden, was er tun will um aus dem Gef�ngnis zu entkommen.
Er kann nicht mehr w�rfeln!
Kartenerlaubt gibt an, ob er eine "Du kommst aus dem Gef�ngnisfrei" Karte
einsetzen darf*)
procedure Kontoausgleichen; virtual; abstract;
(*Spieler soll Konto ausgleichen. Daf�r brauch er die Optionen zum Verwalten der
Grundst�cke, zum Handeln und aufgeben*)
{procedure Handelabgelehnt; virtual; abstract;
(*Der Handel, den der Spieler dieser Instanz vorgeschlagen hat, wurde abgelehnt.
Dies sollte dem Spieler mitgeteilt werden bzw. die Anzeige, dass der andere noch
�berlegt sollte verschwinden*)  }
Procedure Handelsvorschlag(a:tangebot); virtual; abstract;
(* Dem Spieler wird der Handel a vorgeschlagen.*)
procedure Spielerreaktion(angenommen:boolean);  virtual; abstract;
(* Die Reaktion des Mitspielers auf den Handel, bei wahr wurde er angenommen.
Es muss lediglich die Reaktion dem Spieler mitgeteilt werden, nicht mehr! *)
procedure Aufgegeben(id:integer); virtual; abstract;
(* Der Spieler id hat aufgegeben, dies sollte gekennzeichnet werden.*)
function strassen:String; Virtual; abstract;
(*Spieler soll die Datei mit den Strassen ausw�hlen welche verwendet werden
 soll. Die Funktion soll den Pfad zur ausgew�hlten Datei zur�ckgeben. Wird nur
 im Constructor von Tclientsp benutzt.*)
procedure Bitte_Wuerfeln; virtual; abstract;
//Spieler soll M�glichkeit zum W�rfeln erhalten
procedure freiparkengeld_akt; virtual; abstract;
(*Es soll das Frei Parken Geld (Variable: Frei_parken) aktualisiert werden *)
procedure ende; virtual; abstract;
(* Der Server hat das Spiel beendet. Der Spieler darf nur noch Aktionen
   ausf�hren, welche lokal begrenzt sind (also keinen Netzwerkverkehr mehr
   ausl�sen*)
procedure ziehen(id,anzahl:integer); virtual; abstract;
(* Der Spieler Id soll anzahl Felder ziehen. Wenn Anzahl negativ ist, soll
   der Spieler R�ckw�rts ziehen *)

 end;

(*Idee f�r einbindung: Ihr macht eine von tvirtuellgui abgeleitete Klasse,
in der die Methoden implementiert sind. Anschlie�end setzt ihr in der Instanz
von Tclient den Zeiger gui auf eine Instanz von dieser abgeleiteten Klasse.
Ist Jedoch nur eine Idee/ein Vorschlag.
*)

implementation

end.

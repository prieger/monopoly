unit uVirtualAnimation;

interface
uses
  uAngebot;

type

  TVirtualAnimation = class
    public

      {startet die Animation mit der aktuellen Spieleranzahl, muss
       zum Anfang gestartet werden}
      procedure Start;                                        virtual; abstract;

      {ruft Würfelanimation auf mit dem Ergebnis Wurf1,Wurf2}
      procedure wuerfel(wurf1,wurf2:integer);                 virtual; abstract;

      {aktualisiert Geld/Besitzanzeigen}
      procedure aktualisieren;                                virtual; abstract;

      {setzt die Figur auf das jeweilige Feld}
      procedure setSpielerPos(id:integer);                    virtual; abstract;

      {Spieler soll Entscheiden, was er tun will um aus dem Gefängnis zu entkommen
       Kartenerlaubt gibt an, ob er eine "Du kommst aus dem Gefängnisfrei" Karte
       einsetzen darf}
      procedure Gefaegniswahl(KarteErl : Boolean);            virtual; abstract;

      {Spieler soll Entscheiden, was er tun will um aus dem Gefängnis zu entkommen.
        Er kann nicht mehr würfeln!
        Kartenerlaubt gibt an, ob er eine "Du kommst aus dem Gefängnisfrei" Karte
        einsetzen darf}
      procedure gefaengnis3(KarteErl : Boolean);              virtual; abstract;

      {zeigt einen Dialog ob der Spieler die aktuelle Strasse kaufen will}
      procedure kaufen;                                       virtual; abstract;

      {zeigt einen Dialog mit der Nachricht Text}
      procedure Nachricht(Text:String);                       virtual; abstract;

      {fragt Spieler ob er die Grundstücke verwalten will, Handeln oder seinen
       Zug beenden möchte}
      procedure freihandeln;                                  virtual; abstract;

      {zeigt ein Dialog mit der Nachricht, dass der Spieler seine Schulden
       begleichen muss und gibt dann Optionen zum freihandeln frei}
      procedure Kontoausgleichen;                             virtual; abstract;

      {zeigt in Dialog der das vorgeschlagene Angebot Ablehnt}
      procedure Handelabgelehnt;                              virtual; abstract;

      {zeigt ein Dialog ob der Spieler das Angebot annimmt}
      Procedure Handelsvorschlag(aAngebot:TAngebot);          virtual; abstract;

      {Die Reaktion des Mitspielers auf den Handel, bei wahr wurde er angenommen.
       Es muss lediglich die Reaktion dem Spieler mitgeteilt werden, nicht mehr!}
      procedure Spielerreaktion(angenommen:boolean);          virtual; abstract;

      {Spieler soll die Datei mit den Strassen auswählen welche verwendet werden
       soll. Die Funktion soll den Pfad zur ausgewählten Datei zurückgeben. Wird nur
       im Constructor von Tclientsp benutzt.}
      function strassen:String;                               virtual; abstract;

      {Spieler soll Möglichkeit zum Würfeln erhalten}
      procedure Bitte_Wuerfeln;                               virtual; abstract;

      {Es soll das Frei Parken Geld (Variable: Frei_parken) aktualisiert werden}
      procedure freiparkengeld_akt;                           virtual; abstract;

      {Der Server hat das Spiel beendet. Der Spieler darf nur noch Aktionen
       ausführen, welche lokal begrenzt sind (also keinen Netzwerkverkehr mehr
       auslösen}
      procedure ende;                                         virtual; abstract;

      {Figur des Spielers ID wird entfernt}
      procedure aufgeben(ID : Integer);                       virtual; abstract;

  end;


implementation

END.

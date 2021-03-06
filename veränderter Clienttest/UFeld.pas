unit UFeld; //enthält TFeld und Ableitungen davon sowie TSpieler!


interface
uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uEreignis;

  type
  TSpieler = Class;
  TFeld = Class
  private
    Spiel : TObject;
  public
    ID : integer;   //ID vom Feld  ô.Ô
    Name : string;  //Beschriftung (z.b."Los" oder "Schlossallee")
    Typ : integer;  //Zeigt ob Feld TBesitz, TSteuerfeld, TSonderfeld, TEcke ist (1,2,3,4)
  end;

TBesitz = Class(TFeld) //Feld, das in den Besitz eines Spielers übergehen kann (nicht muss)
    Preis : integer;            //Kaufpreis
    Typ2 : integer;             //Strasse, Bahnhof, Werk (1,2,3) - alternativ GetType
    Besitzer: Integer;         //Besitzer , -1: Feld hat keinen Besitzer
    Zustand : Integer; //Hyp. ist -1, normal ist 0, bei Straßen: Anzahl der Häuser: Häuser (1-4), Hotel ist 5
    function GetMiete(augenzahl : Integer) : integer;    virtual;abstract; //gibt die Miete zurück
end;

    TStrasse = Class(TBesitz)
      Farbe: TColor;                   //Farbe des Balkens (z.B. Blau bei der Schlossallee)
      Mieten : array [0..5] of integer; // Mieten der Straßen ohne Häuser(0), mit Häusern(1-4), mit Hotel(5)                   
      Hypothek : integer;               // erhaltenes Geld bei Anforderung einer Hypothek
      Baukosten : integer;              // Kosten pro Haus bzw. Hotel
      constructor create (parSpiel : TObject; id_par : Integer;fa : TColor; nam : String;pre,m1,m2,m3,m4,m5,m6,bau,hyp : Integer); //ID, Farbe, Name, Preis, Mieten, Baukosten, Hypothek
      function GetMiete(augenzahl : Integer) : integer;    override;
    end;

      TBahnhof = Class(TBesitz)
        Mieten : array [1..4] of integer; //Mieten für Zustand = 1..4
        Hypothek : integer;
        constructor create(parSpiel : TObject;id_par : Integer;nam : String;pre,m1,m2,m3,m4,hyp : Integer); //ID, Name, Preis, Mieten, Hypothek
        function GetMiete(augenzahl : Integer) : integer;    override;
    end;

    TWerk = Class(TBesitz)
        Mieten : array [1..2] of integer; //Mieten-Faktor für Zustand = 1..2
        Hypothek : integer;
        constructor create(parSpiel : TObject;id_par : Integer;nam : String;pre,m1,m2,hyp : Integer); //ID, Name, Preis, Mieten-Faktoren, Hypothek
        function GetMiete(augenzahl : Integer) : integer;    override;
    end;



TSteuerfeld = Class(TFeld)
    Steuer : integer;
    constructor create(parSpiel : TObject;id_par : Integer; nam : String; st : Integer);
end;


TSonderfeld = Class(TFeld) //Ereignis- und Gemeinschaftsfelder, Ecken, und alle Arten von Sonderfeldern (außer das bereits definierte)
    Sonderfeldtyp : integer; //Ereignisfeld : 0, Gemeinschaftsfeld : 1
    Warteschlange : TWarteschlange; //kommt in TMonopoly
    constructor create(parSpiel : TObject;id_par : Integer; nam : String; typid : Integer);
end;

TEcke = Class(TFeld)
    Eckentyp : integer; //Los : 0, Gefängnis : 1, Frei Parken/ : 2, Gehe in das Gefängnis : 3
    constructor create(parSpiel : TObject;id_par : Integer; nam : String; typid : Integer);
    //Ereignis : TEreignis;
end;

TSpielerDaten = Class
private
prvFeld : Integer;
prvGeld : Integer;
prvGefangen : Boolean;
public
ID: integer; //ID des Spielers
Name: string; //Name des Spielers
IP: string; //IP des Spielers
Port: integer; //Port des Spielers
BesitzAnzahl : integer; //Anzahl der Felder im Besitz des Spielers: keine Felder: 0; ein Feld: 1; ...
Besitz: array of TBesitz; //Array mit den Feldern im Besitz des Spielers, oberstes Eintrag des Arrays: BesitzAnzahl - 1, obere Grenze des Arrays: maxstr aus dem constructor
BahnhofAnzahl : integer; //Anzahl der Bahnhöfe im Besitz des Spielers
WerkAnzahl : integer; //Anzahl der Werke im Besitz des Spielers
Aufgegeben : boolean; //True, wenn Spieler aus dem Spiel ausgeschieden
AnzGefKarten : integer; //Anzahl Gefängnisfreikarten
AnzGefWuerfe : integer; //Anzahl der Würfe, die der Spieler im aktuellen Gefängnisaufenthalt bereits verbraucht hat
property Gefangen : boolean read prvGefangen write prvGefangen; //True, wenn Spieler im Gefängnis
property Feld : Integer read prvFeld write prvFeld; //ID des Feldes, auf dem der Spieler steht
property Geld : Integer read prvGeld write prvGeld; //aktuelles Geld des Spielers
constructor create(parID:Integer;parIP,parName:String;parPort,maxstr:Integer); //parID: ID, parIP: IP, parName: Name, parPort: Port, maxstr: Maximale Anzahl der Straßen, welche der Spieler besitzen kann
end;

  TSpieler= Class(TSpielerDaten)
    private
    //prvFeld : Integer;
    //prvGeld : Integer;
    spiel : TObject;
    procedure FeldAendern(parFeld : integer);
    procedure GeldAendern (parGeld : integer);
    procedure GeheInDasGefaengnis(parGefangen : boolean);

    public

    //fehlende Attribute siehe Class SpielerDaten

    property Feld: integer read prvFeld write FeldAendern; //ID des Feldes, auf dem der Spieler steht - bei Veränderung wird eine Nachricht an alle Spieler gesendet
    property Geld: integer read prvGeld write GeldAendern; //aktuelles Geld des Spielers - bei Veränderung wird eine Nachricht an alle Spieler gesendet
    property Gefangen : boolean read prvGefangen write GeheInDasGefaengnis; //True, wenn Spieler im Gefängnis, wenn von false auf true gesetzt: AnzGefWuerfe := 0
    constructor create(parSpiel : TObject;parID:Integer;parIP,parName:String;parPort,maxstr:Integer); //parSpiel: Zeiger auf das Monopoly-Spiel, parID: ID, parIP: IP, parName: Name, parPort: Port, maxstr: Maximale Anzahl der Straßen, welche der Spieler besitzen kann
    procedure Ziehen (augen : integer); //zieht um augen, Nachricht an alle Spieler, dass der Spieler "normal" weitergeht (keine Teleportation)
end;

implementation
uses uMonopoly;
constructor TStrasse.create (parSpiel : TObject;id_par : Integer;fa : TColor; nam : String;pre,m1,m2,m3,m4,m5,m6,bau,hyp : Integer);
begin
  Spiel := parSpiel;
  ID := id_par;
  Name := nam;
  Typ := 1;
  Preis := pre;
  Typ2 := 1;
  Besitzer := -1;  //zum Laden erweiterbar
  Farbe := fa;
  Zustand := 0; //zum Laden erweiterbar
  Mieten[0]:=m1;
  Mieten[1]:=m2;
  Mieten[2]:=m3;
  Mieten[3]:=m4;
  Mieten[4]:=m5;
  Mieten[5]:=m6;
  Baukosten := bau;
  Hypothek := hyp;
end;

constructor TBahnhof.create(parSpiel : TObject;id_par : Integer;nam : String;pre,m1,m2,m3,m4,hyp : Integer);
begin
  Spiel := parSpiel;
  ID := id_par;
  Name := nam;
  Typ := 1;
  Preis := pre;
  Typ2 := 2;
  Besitzer := -1; //zum Laden erweiterbar
  Zustand := 1; //zum Laden erweiterbar
  Mieten[1] := m1;
  Mieten[2] := m2;
  Mieten[3] := m3;
  Mieten[4] := m4;
  Hypothek := hyp;
end;

constructor TWerk.create(parSpiel : TObject;id_par : Integer;nam : String;pre,m1,m2,hyp : Integer);
begin
  Spiel := parSpiel;
  ID := id_par;
  Name := nam;
  Typ := 1;
  Preis := pre;
  Typ2 := 3;
  Besitzer := -1; //zum Laden erweiterbar
  Zustand := 1; //zum Laden erweiterbar
  Mieten[1] := m1;
  Mieten[2] := m2;
  Hypothek := hyp;
end;

constructor TSteuerfeld.create(parSpiel : TObject;id_par : Integer; nam : String; st : Integer);
begin
  Spiel := parSpiel;
  ID := id_par;
  Name := nam;
  Typ := 2;
  Steuer := st;
end;

constructor TSonderfeld.create(parSpiel : TObject;id_par : Integer; nam : String; typid : Integer);
begin
  Spiel := parSpiel;
  ID := id_par;
  Name := nam;
  Typ := 3;
  Sonderfeldtyp := typid;
end;

constructor TEcke.create(parSpiel : TObject;id_par : Integer; nam : String; typid : Integer);
begin
  Spiel := parSpiel;
  ID := id_par;
  Name := nam;
  Typ := 4;
  Eckentyp := typid;
end;



function TStrasse.GetMiete(augenzahl : Integer) : integer;   //NOCH ZU MACHEN: höhere Miete, wenn ein Spieler alle Straßen einer Farbe besitzt
begin
  If (Besitzer > -1) and (Zustand > -1) then result := Mieten[Zustand] else result:=0;
end;

function TBahnhof.GetMiete(augenzahl : Integer) : integer;
begin
  If (Besitzer > -1) and (Zustand > -1) then result := Mieten[TMonopoly(Spiel).Spieler[Besitzer].BahnhofAnzahl] else result:=0;
end;

function TWerk.GetMiete(augenzahl : Integer) : integer;
begin
    If (Besitzer > -1) and (Zustand > -1) then result := Mieten[TMonopoly(Spiel).Spieler[Besitzer].WerkAnzahl]*augenzahl else result:=0;
end;

Constructor TSpielerDaten.create(parID:Integer;parIP,parName:String;parPort,maxstr:Integer);
begin
    Feld:=0;
    Geld:=0;
    setLength(besitz,maxstr);
    BesitzAnzahl := 0;
    BahnhofAnzahl := 0;
    WerkAnzahl := 0;
    Name:=parName;
    IP:=parIP;
    Port:=parPort;
    ID:=parID;
    Gefangen:=false;
    Aufgegeben:=false;
    AnzGefKarten:=0;
    AnzGefWuerfe:=0;
end;

Constructor Tspieler.create(parSpiel : TObject;parID:Integer;parIP,parName:String;parPort,maxstr:Integer);
Begin
    TSpielerDaten(self).create(parID,parIP,parName,parPort,maxstr);
    spiel := parSpiel;
    Feld:=0;
    Geld:=0;
    setLength(besitz,maxstr);
    BesitzAnzahl := 0;
    BahnhofAnzahl := 0;
    WerkAnzahl := 0;
    Name:=parName;
    IP:=parIP;
    Port:=parPort;
    ID:=parID;
    Gefangen:=false;
    Aufgegeben:=false;
    AnzGefKarten:=0;
    AnzGefWuerfe:=0;
end;

procedure TSpieler.FeldAendern(parFeld : Integer);
begin
  prvFeld := parFeld;
  TMonopoly(spiel).netz.sendtoallclients('spos',inttostr(Feld)+';'+inttostr(id)+'|');
end;

procedure TSpieler.Ziehen(augen : Integer);
begin                                                          
  prvFeld := (prvFeld+augen) mod TMonopoly(spiel).maxstr;
  TMonopoly(spiel).netz.sendtoallclients('szug',inttostr(Feld)+';'+inttostr(id)+'|');
end;


procedure TSpieler.GeldAendern(parGeld : Integer);
begin
  prvGeld := parGeld;
  TMonopoly(spiel).netz.SendToAllClients('geld',inttostr(id)+';'+inttostr(Geld)+'|');
end;

procedure TSpieler.GeheInDasGefaengnis(parGefangen : Boolean);
begin
  if (parGefangen) and (not prvGefangen) then AnzGefWuerfe := 0;
  prvGefangen := parGefangen;
end;

end.

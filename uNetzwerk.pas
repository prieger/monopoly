unit uNetzwerk;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, Dialogs, ScktComp, StdCtrls, uMonopoly, uKommunikation, uClient;

   type TIntInt = class
        erstes : integer;
        zweites : integer;
   end;

   type TIntBool = class
        erstes : integer;
        zweites : boolean;
   end;

   type TIntIntInt = class
        erstes : integer;
        zweites : integer;
        drittes : integer;
   end;

   type TIntIntStr = class
        erstes : integer;
        zweites : integer;
        drittes : string;
   end;

  function CutPayload1 (PL: string) : TIntInt;
  function CutPayload2 (PL: string) : TIntBool;
  function CutPayload3 (PL: string) : TIntIntInt;
  function CutPayload4 (PL: string) : TIntIntStr;
  procedure ServerAction (Socks: TCustomWinSocket; Frm : TForm; Action, Payload : string; Monopoly : TMonopoly);
  procedure ClientAction (Frm : TForm; Action, Payload : string; Spieler : TClientSP);

implementation

procedure ServerAction (Socks: TCustomWinSocket; Frm : TForm; Action, Payload : string; Monopoly : TMonopoly);
 var 
  Sckt: TServer;
  i : integer;

 begin
  Sckt := TServer.create(TServerSocket(Frm.Findcomponent('ServerSocket1')));

   if action = 'term' then
      //shutdown server
      begin 
      Sckt.SendToAllClients('term', 'server shutdown');
      application.terminate;
      end;

   if action = 'chat' then
      //open chat message
      begin
//andere Variante beinhaltet noch: if Monopoly.Spieleranzahl > 0 then
      i := 0;
      while (i <= Monopoly.Spieleranzahl-1)
        and ((NOT(Monopoly.Spieler[i].IP = Socks.RemoteAddress))
              or (NOT(Monopoly.Spieler[i].Port = Socks.RemotePort)))
              do inc(i);
      Sckt.SendToAllClients('chat', (Monopoly.Spieler[i].Name + ': ' + Payload));
      TMemo(Frm.FindComponent('Chatmemo')).Lines.Add(Monopoly.Spieler[i].Name + ': ' + Payload)
      end;

   if action = 'name' then
      //set client name
      begin
      Monopoly.name(Payload, Socks.RemoteAddress, Socks.Remoteport);
      i := -1;
      repeat inc(i)
      until (Monopoly.Spieler[i].IP = Socks.RemoteAddress) and (Monopoly.Spieler[i].Port = Socks.RemotePort);
      TMemo(Frm.FindComponent('Memo1')).Lines.Add(Monopoly.Spieler[i].Name + '(' + Monopoly.Spieler[i].IP + ':' + inttostr(Monopoly.Spieler[i].Port) + ')');     //verbindungsmemo
      if Monopoly.Spieleranzahl > 1 then TButton(Frm.FindComponent('Button2')).enabled := true; //Spiel starten Button
      TButton(Frm.FindComponent('Button3')).enabled := true;         //Chat-Senden Button
      end;

   if action = 'kauf' then
      //mitteilung, dass stra�e gekauft wurde
//Stra�en-ID soll �bergeben werden? ohne Parameter
      begin
      if Payload = 'true' then Monopoly.kauf(true)
	  else Monopoly.kauf(false);
	  end;

   if action = 'hypo' then
      //hypothek anwenden, �bergeben wird die ID der stra�e
      Monopoly.hypo(Payload);

  if action = 'baue' then
      //id der Stra�e; auf- oder abbau (aufbau := true)
      Monopoly.baue(CutPayload2(Payload).erstes, CutPayload2(Payload).zweites);
                            
   if action = 'geza' then
      //spieler @ gef�ngnis; �bergeben wird die entscheidung, was getan wird (gef frei karte, w�rfeln oder zahlen)
//Spieler nur f�hig zu w�rfeln oder zu zahlen?
      // 1:zahlen,2:W�rfeln, 3:Karte
      Monopoly.geza(Payload);

   if action = 'zuge' then
      //spieler ist fertig mit seinem zug, n�chster spieler ist dran
      Monopoly.nextspieler;

   if action = 'wuer' then
      // Signal, dass Server w�rfeln soll
      // Spieler m�chte w�rfeln lassen
      Monopoly.wuer;

   if action = 'aufg' then
      //Spieler m�chte aufgeben, �bergeben wird die ID des Spielers, der aufgeben m�chte.
      Monopoly.aufg(Payload); 

   if action = 'hare' then
      //reaktion auf einen vorgeschlagenen Handel
      begin
      if Payload = 'true' then Monopoly.hare(true)
      else Monopoly.hare(false);
      end;         
	if action = 'chan' then
       //der Spieler macht das im String enthaltene angebot
       Monopoly.chan(Payload);	   

{if action = 'gefh' then
    //r�ckgabe welche handlung vollzogen werden soll
    Monopoly.gefh(Payload);}

 end;

 procedure ClientAction (Frm : TForm; Action, Payload : string; Spieler: TClientSP);
 var
  Sckt : TClientSocket;
  wrfl1, wrfl2 : integer;
  pos, zustand : integer;
  geld : integer;
  FID, EID, SID : integer;
  gefangen : boolean;

 begin
    Sckt := TClientSocket(Frm.Findcomponent('ClientSocket1'));
    if action = 'term' then
       //server was shutdown, exit game
       begin 
       ShowMessage(Payload);
       application.terminate;
       end;

    if action = 'chat' then
       //open chat message
       TMemo(Frm.FindComponent('Chatmemo')).Lines.Add(Payload);


    if action = 'wurf' then
       //wuerfelergbnisse werden �bergeben(int int)
       begin
       wrfl1 := CutPayload1(Payload).erstes;
       wrfl2 := CutPayload1(Payload).zweites;
       Spieler.wurf(wrfl1, wrfl2);
       end;

    if action = 'spos' then
       //�bergeben wird die position, trennzeichen';' und die ID des Spielers
       //grafische Darstellung des Spielersymbols
       begin
       pos := CutPayload1(Payload).erstes;
       SID := CutPayload1(Payload).zweites;
       Spieler.spos(pos, SID);
       end;

    if action = 'gefa' then
       //spieler ID + ';' + boolean: gefangen oder nicht
       begin
       SID := CutPayload2(Payload).erstes;
       gefangen := CutPayload2(Payload).zweites;
       Spieler.gefa(SID, gefangen);
       end;

    if action = 'geld' then
       //�bergeben wird eine Spieler ID, das trennzeichen ';' und sein aktueller Geldstand
       begin
       SID := CutPayload1(Payload).erstes;
       geld := CutPayload1(Payload).zweites;
       Spieler.geld(SID, geld);
       end;

    if action = 'besi' then
       //�bergeben wird eine Feld ID, das trennzeichen ';', die dazugeh�rige Besitzer ID, trennzeichen';' und der Zustand des Feldes
       begin
       FID := CutPayload3(Payload).erstes;
       SID := CutPayload3(Payload).zweites;
       zustand := CutPayload3(Payload).drittes;
       Spieler.besi(FID, SID, zustand);
       end;

    if action = 'gefg' then
       //�bergeben wird, ob der spieler die m�glichkeit hat, folgende entscheidung zu treffen: was zu kaufen oder weiter zu w�rfeln (pasch)
//Neue ClientServer: ob der Spieler Karten einsetzen kann     -    was nun?
       begin
       if Payload = 'true' then Spieler.gefg(true)
       else Spieler.gefg(false);
       end;

   if action = 'hndl' then
       //client soll handlung durchf�hren und dann mit befehl 'gefh' zur�ckgeben
//ClientServer(neue Version): Spieler soll handlung angeben     -   was nun? (gleiche aktion gemeint - oder neuer Typus)
       Spieler.hndl(Payload); 

    if action = 'mesg' then
       //show Message
       ShowMessage(Payload);

    if action = 'fhnd' then
       //Spieler kann eigene Aktionen ausf�hren
       Spieler.fhnd; 

    if action = 'gekg' then
       //Spieler muss entscheiden ob er KArte einsetzt oder Zahlt; nach dem dritten W�rfeln
       begin
       if Payload = 'true' then Spieler.gekg(true)
       else Spieler.gekg(false);
       end;                   

    if action = 'spid' then
       //Spieler wird seine id mitgeteielt
       Spieler.spid(Payload);   

    if action = 'btnc' then
       //Spieler ist dran; Signal zum w�rfeln �ber button geben
       Spieler.btnc;

    if action = 'koau' then
       //Spieler muss Konto ausgleichen
	 //�bergabe der Spieler-ID oder des Kontostandes?  
       Spieler.koau;  

    if action = 'hars' then
       //reaktion des MItspielers auf Handel
       begin
       if Payload = 'true' then Spieler.hars(true)
       else Spieler.hars(false);
       end;                
    
    if action = 'aufe' then
	   //aufgabe eines spielers. �bergeben wird die ID des spielers.
	   Spieler.aufe(strtoint(Payload));

    if action = 'spin' then
       //gesamtzahl an Spielern, id, name des Spielers id
//welche ID? und Name des Spielers ID soll gemeint sein, welcher Spieler zu der ID geh�rt?	   
       Spieler.spin(CutPayload4(Payload).erstes, CutPayload4(Payload).zweites, CutPayload4(Payload).drittes);
                 
    if action = 'ende' then
       //der destructor des servers wurde aufgerufen
       Spieler.ende; 

    if action = 'szug' then
       //id des Spielers, Anzahl der Z�g die der Spieler ziehen soll
       Spieler.szug(CutPayload1(Payload).erstes, CutPayload1(Payload).zweites);
                      
    if action = 'kost' then
      //�bergeben wird SID und dazugeh�riger Kontostand
      begin
      SID := CutPayload1(Payload).erstes;
      geld := CutPayload1(Payload).zweites;
      Spieler.kost(SID, geld);
      end;
	
	if action = 'shan' then
	   //dem Spieler wird das im String enthaltene Angebot gemacht
	   Spieler.shan(Payload);
	   
	if action = 'star' then
       //das Spiel wurde gestartet
       Spieler.star;	   
 end;

 function CutPayload1 (PL: string) : TIntInt;
 var 
  i : integer;
  
 begin
  i := 1;
  result := TIntInt.Create;
  result.erstes := 0;
  repeat
    result.erstes := strtoint(inttostr(result.erstes) + copy(PL, i, 1));
    inc(i);
  until copy(PL, i, 1) = ';';
  result.zweites := strtoint(copy(PL, i+1, length(PL)-i));
 end;

 function CutPayload2 (PL: string) : TIntBool;
 var 
  i : integer;

 begin
  i := 1;
  result := TIntBool.Create;
  result.erstes := 0;
  repeat
    result.erstes := strtoint(inttostr(result.erstes) + copy(PL, i, 1));
    inc(i);
   until copy(PL, i, 1) = ';';
  if copy(PL, i+1, length(PL)-i) = 'true' then result.zweites := true
  else result.zweites := false;
 end;

 function CutPayload3 (PL: string) : TIntIntInt;
 var 
  i : integer;
  
 begin
  i := 1;
  result := TIntIntInt.Create;
  result.erstes := 0;
  result.zweites := 0;
  repeat
    result.erstes := strtoint(inttostr(result.erstes) + copy(PL, i, 1));
    inc(i);
  until copy(PL, i, 1) = ';';
  inc(i);
  repeat
    result.zweites := strtoint(inttostr(result.zweites) + copy(PL, i, 1));
    inc(i);
  until copy(PL, i, 1) = ';';
  result.drittes := strtoint(copy(PL, i+1, length(PL)-i));
 end;

 function CutPayload4 (PL: string) : TIntIntStr;
 var 
  i : integer;

 begin
  i := 1;
  result := TIntIntStr.Create;
  result.erstes := 0;
  result.zweites := 0;
  repeat
    result.erstes := strtoint(inttostr(result.erstes) + copy(PL, i, 1));
    inc(i);
   until copy(PL, i, 1) = ';';
   inc(i);
   repeat
    result.zweites := strtoint(inttostr(result.zweites) + copy(PL, i, 1));
    inc(i);
   until copy(PL, i, 1) = ';';
  result.drittes := copy(PL, i+1, length(PL)-i);
  end;

end.

unit uguivecht;

interface
uses uVirtualAnimation,uangebot;

type tguivecht=class(tVirtualAnimation)
      procedure Start;  override;                                        
      procedure wuerfel(wurf1,wurf2:integer);  override;                 
      procedure aktualisieren;  override;                                
      procedure setSpielerPos(id:integer);  override;                    
      procedure Gefaegniswahl(KarteErl : Boolean);  override;            
      procedure gefaengnis3(KarteErl : Boolean);  override;              
      procedure kaufen;  override;                                       
      procedure Nachricht(Text:String);  override;                       
      procedure freihandeln;  override;                                  
      procedure Kontoausgleichen;  override;                             
      procedure Handelabgelehnt;  override;                              
      Procedure Handelsvorschlag(aAngebot:TAngebot);  override;
      procedure Spielerreaktion(angenommen:boolean);  override;          
      function strassen:String;  override;                               
      procedure Bitte_Wuerfeln;  override;                               
      procedure freiparkengeld_akt;  override;                           
      procedure ende;  override;                                         
      procedure aufgeben(ID : Integer);  override;
 end;


implementation

      procedure tguivecht.Start;  Begin  end;                                        
      procedure tguivecht.wuerfel(wurf1,wurf2:integer);  Begin  end;                 
      procedure tguivecht.aktualisieren;  Begin  end;                                
      procedure tguivecht.setSpielerPos(id:integer);  Begin  end;                    
      procedure tguivecht.Gefaegniswahl(KarteErl : Boolean);  Begin  end;            
      procedure tguivecht.gefaengnis3(KarteErl : Boolean);  Begin  end;              
      procedure tguivecht.kaufen;  Begin  end;                                       
      procedure tguivecht.Nachricht(Text:String);  Begin  end;                       
      procedure tguivecht.freihandeln;  Begin  end;                                  
      procedure tguivecht.Kontoausgleichen;  Begin  end;                             
      procedure tguivecht.Handelabgelehnt;  Begin  end;                              
      Procedure tguivecht.Handelsvorschlag(aAngebot:TAngebot);  Begin  end;          
      procedure tguivecht.Spielerreaktion(angenommen:boolean);  Begin  end;          

      function tguivecht.strassen:String;
       Begin
       Result:='C:\Users\Phillip\Documents\Eigene Dokumente\Programmieren\Delphi\monopoly\Kopie von spielbrett.txt';
       end;

      procedure tguivecht.Bitte_Wuerfeln;  Begin  end;                               
      procedure tguivecht.freiparkengeld_akt;  Begin  end;                           
      procedure tguivecht.ende;  Begin  end;                                         
      procedure tguivecht.aufgeben(ID : Integer);  Begin  end;                       

end.

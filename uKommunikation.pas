unit uKommunikation;

interface

uses ScktComp;

type TServer = class
     S : TServerSocket;
     procedure SendToClient (SpNr : cardinal; Action, Payload : string);
     procedure SendToAllClients (Action, Payload : string);
     constructor create(sock: TServerSocket);
     end;

type TClient = class
     S : TClientSocket;
     procedure SendToServer (Action, Payload : string);
     procedure SetIp (IP: string);
     constructor create(sock: TClientSocket);
     end;

implementation

 constructor TClient.create(sock:TClientSocket);
 begin
  S := sock;
 end;

 constructor TServer.create(sock:TServerSocket);
 begin
  S := sock;
 end;

 procedure TServer.SendToAllClients( Action, Payload : string);
 var 
  i : integer;
 begin
  if S.Socket.activeconnections > 0 then
  for i := 0 to S.socket.activeconnections -1 do
  S.socket.connections[i].sendText(action + payload); 
 end;

procedure TClient.SendToServer (Action, Payload : string);
 begin
  S.socket.SendText(action + payload);
 end;

procedure TServer.SendToClient (SpNr : cardinal; Action, Payload : string);
 begin
  S.socket.connections[SpNr-1].SendText(action + payload);
 end;

procedure TClient.SetIp (IP: string);
 begin
  S.active := false;
  S.Address := IP;
  S.Port := 1337;
  S.Active := true;
end;

end.
 

unit Connection;

interface

uses
  FireDAC.DApt, FireDAC.Stan.Option, FireDAC.Stan.Intf, FireDAC.UI.Intf,
  FireDAC.Stan.Error, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client,

  FireDAC.Phys.FB, FireDAC.Phys.FBDef, System.Classes, FireDAC.Comp.UI, FireDAC.Phys.ODBCBase,
  System.IniFiles, System.SysUtils, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef;

var
  FConnection : TFDConnection;

  function SetupConnection(FConn: TFDConnection): String;
  function Connect : TFDConnection;
  procedure Disconect;
  procedure doSaveLog(Msg:String);

implementation

function SetupConnection(FConn: TFDConnection): string;
var
  arq_ini : string;
  ini     : TIniFile;
begin
  try
    try
      arq_ini := GetCurrentDir + '\pokedex-horse.ini';

      // Verifica se INI existe...
      if NOT FileExists(arq_ini) then
      begin
        Result := 'Arquivo INI n�o encontrado: ' + arq_ini;
        doSaveLog(result);
        Exit;
      end;

      // Instanciar arquivo INI...
      ini := TIniFile.Create(arq_ini);

      // Buscar dados do arquivo fisico...
      FConn.Params.Values['DriverId']   := ini.ReadString('Banco de Dados', 'DriverName', '');
      FConn.Params.Values['Server']     := ini.ReadString('Banco de Dados', 'Server', '');
      FConn.Params.Values['Database']   := ini.ReadString('Banco de Dados', 'Database', '');
      FConn.Params.Values['user_name']  := ini.ReadString('Banco de Dados', 'user_name', '');
      FConn.Params.Values['Password']   := ini.ReadString('Banco de Dados', 'Password', '');
      FConn.Params.Add('Port=' + ini.ReadString('Banco de Dados', 'Port', '1433'));

      Result := 'OK';
    except on ex:exception do
      begin
        Result := 'Erro ao configurar banco: ' + ex.Message;
        doSaveLog(Result);
      end;
    end;
  finally
    if Assigned(ini) then
        ini.DisposeOf;
  end;
end;

function Connect : TFDConnection;
begin
  FConnection := TFDConnection.Create(nil);
  SetupConnection(FConnection);
  FConnection.Connected := true;

  Result := FConnection;
end;

procedure Disconect;
begin
  if Assigned(FConnection) then
  begin
      if FConnection.Connected then
          FConnection.Connected := false;

      FConnection.Free;
  end;
end;

procedure doSaveLog(Msg: String);
var
  loLista: Tstringlist;
begin
  try
    loLista := Tstringlist.create;
    try
      if FileExists('c:\log.log') then
        loLista.LoadFromFile('c:\log.log');
      loLista.add(TimeToStr(now) + ': ' + Msg);
    except
      on E: Exception do
        loLista.add(TimeToStr(now) + ': erro ' + E.Message);
    end;
  finally
    loLista.SaveToFile('c:\log.log');
    loLista.free;
  end;
end;

end.

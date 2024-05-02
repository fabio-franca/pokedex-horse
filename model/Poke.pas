unit Poke;

interface

uses FireDAC.Comp.Client, Data.DB, System.SysUtils, Connection, UtilFunctions;

type
  TPoke = class
  private
    FID          : Integer;
    FName        : String;
    FLv          : Integer;
    FType        : String;
    FRarity      : String;
    FDateInsert  : TDateTime;
  public
    constructor Create;
    destructor Destroy; override;

    property ID          : Integer   read  FID            write FID;
    property Name        : String    read  FName          write FName;
    property Lv          : Integer   read  FLv            write FLv;
    // ira acontece um erro ao tenta execultar por causa do FType([dcc32 Error] Poke.pas(23): E2004 Identifier redeclared: 'FType')
    property FType       : String    read  FType          write FType;
    property Rarity      : String    read  FRarity        write FRarity;
    property DateInsert  : TDateTime read  FDateInsert    write FDateInsert;

    function insert (out erro: String): Boolean;

  end;

implementation

{ Poke }

constructor TPoke.Create;
begin
  Connection.Connect;
end;

destructor TPoke.Destroy;
begin
  Connection.Disconect;
end;

function TPoke.Insert(out erro: String): Boolean;
var
  Query    : TFDQuery;
  NextPoke : Integer;
begin
  try
    CriarQuery(Query);

    Query.Close;
    Query.SQL.Clear;

    Query.SQL.Add('INSERT INTO  poke (Name, Lv, Type, Rarity, DateInsert) ');
    Query.SQL.Add('VALUES (:NAME, :LV, :TYPE, :RARITY, :DATEINSERT)       ');

    Query.ParamByName('NAME').Value       := Name;
    Query.ParamByName('LV').Value         := Lv;
    Query.ParamByName('TYPE').Value       := FType;
    Query.ParamByName('RARITY').Value     := Rarity;
    Query.ParamByName('DATEINSERT').Value := DateInsert;

    Query.ExecSQL;
    Query.Free;

    //Codibair := UltimoId();

    Erro := '';
    Result := True;

  except on E: Exception do
    begin
      Erro := 'Falha ao salvar registro: ' + e.Message;
      Result := False;
    end;
  end;

end;

end.

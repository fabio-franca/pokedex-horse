unit Skill;

interface

uses FireDAC.Comp.Client, Data.DB, System.SysUtils, Connection, UtilFunctions;

type
  TSkill = class
  private
    FId          : Integer;
    FName        : String;
    FPokeId      : Integer;

  public
    constructor Create;
    destructor Destroy; override;

    property ID          : Integer   read  FId            write FId;
    property Name        : String    read  FName          write FName;
    property PokeId      : Integer   read  FPokeId        write FPokeId;

    function insert (out erro: String): Boolean;

  end;

implementation

{ Skill }

constructor TSkill.Create;
begin
  Connection.Connect;
end;

destructor TSkill.Destroy;
begin
  Connection.Disconect;
end;

function TSkill.Insert(out erro: String): Boolean;

var
  Query    : TFDQuery;
  NextPoke : Integer;
begin
  try
    CriarQuery(Query);

    Query.Close;
    Query.SQL.Clear;

    Query.SQL.Add('INSERT INTO  skill (Name, PokeId) ');
    Query.SQL.Add('VALUES (:NAME ');

    Query.ParamByName('NAME').Value   := Name;
    Query.ParamByName('POKEID').Value := PokeId;

    Query.ExecSQL;
    Query.Free;

    //Codibair := UltimoId();

    Erro   := '';
    Result := True;

  except on E: Exception do
    begin
      Erro   := 'Falha ao salvar registro: ' + e.Message;
      Result := False;
    end;
  end;
end;
end.




// Cria um ID e Nome das skill FId, FName, FPokeId
// Cria um costrutor de propriadades, al�m  de uma fun��o de incert

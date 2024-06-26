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

    function InsertPokeSkil(out erro: String): Boolean;
    function ListSkill(texto: String; out erro: String): TFDQuery;
    function GetIdPoke(id: Integer; out erro: String): TFDQuery;
    function LastPokeIdSkill : Integer;

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

function TSkill.InsertPokeSkil(out erro: String): Boolean;

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

    Erro   := '';
    Result := True;

  except on E: Exception do
    begin
      Erro   := 'Falha ao salvar registro: ' + e.Message;
      Result := False;
    end;
  end;
end;

function TSkill.ListSkill(texto: String; out erro: String): TFDQuery;
var
  Query: TFDQuery;
begin
  try
    CriarQuery(Query);
    Query.SQL.Add('SELECT * FROM poke');

    if texto <> '' then
      Query.SQL.Add(' WHERE name = '''+ texto +''' ');

    Query.Open();

    erro := '';

    Result := Query;
  except on e:exception do
    begin
      erro := 'Falha ao obter lista: ' + e.Message;
      Result := nil;
    end;
  end;

end;

function TSkill.GetIdPoke(id: Integer; out erro: String): TFDQuery;
var
  Query: TFDQuery;
begin
  try
    // Cria a query usando a conex�o do banco de dados
    CriarQuery(Query);
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('SELECT * FROM poke ');
    Query.SQL.Add(' WHERE id = :ID    ');
    Query.ParamByName('ID').AsInteger := id;
    Query.Open;

    if not Query.IsEmpty then
    begin
      Result := Query;
    end
    else
    begin
      erro := 'Pokemon n�o encontrado';
      Result := nil;
    end;
  except
    on E: Exception do
    begin
      erro := 'Falha ao obter pokemon: ' + E.Message;
      Result := nil;
    end;
  end;
end;

// cria uma fun��o que retoner um inteiro do utimo pokemon, fazendo um select retonando iD
function TSkill.LastPokeIdSkill : Integer;
var
  Query: TFDQuery;
begin
  try
    // Cria a query usando a conex�o do banco de dados
    CriarQuery(Query);
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('SELECT MAX(ID) AS ID FROM skill ');
    Query.Open;

    if not Query.IsEmpty then
    begin
      Result := Query.FieldByName('ID').AsInteger;
    end
    else
    begin
      Result := 0;
    end;
  except
    on E: Exception do
    begin
      Result := 0;
    end;
  end;
end;

end.

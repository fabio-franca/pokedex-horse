unit Poke;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, Connection, UtilFunctions,
  System.JSON;

type
  TPoke = class
  private
    FID          : Integer;
    FName        : String;
    FLv          : Integer;
    FTypePoke    : String;
    FRarity      : String;
    FDateInsert  : TDateTime;
  public
    constructor Create;
    destructor Destroy; override;

    property ID          : Integer   read  FID            write FID;
    property Name        : String    read  FName          write FName;
    property Lv          : Integer   read  FLv            write FLv;
    property TypePoke    : String    read  FTypePoke      write FTypePoke;
    property Rarity      : String    read  FRarity        write FRarity;
    property DateInsert  : TDateTime read  FDateInsert    write FDateInsert;

    function Insert(out erro: String): Boolean;
    function List(texto: String; out erro: String): TFDQuery;
    function GetIdPoke(id: Integer; out erro: String): TFDQuery;
    function LastPokeId : Integer;

  end;

implementation

{ TPoke }

constructor TPoke.Create;
begin
  Connection.Connect;
end;

destructor TPoke.Destroy;
begin
  //Connection.Disconnect;
  inherited;
end;

function TPoke.Insert(out erro: String): Boolean;
var
  Query    : TFDQuery;
begin
  try
    CriarQuery(Query);

    Query.Close;
    Query.SQL.Clear;

    Query.SQL.Add('INSERT INTO poke (name, lv, typepoke, rarity) ');
    Query.SQL.Add('VALUES (:NAME, :LV, :TYPEPOKE, :RARITY)');

    Query.ParamByName('NAME').Value       := Name;
    Query.ParamByName('LV').Value         := Lv;
    Query.ParamByName('TYPEPOKE').Value   := TypePoke;
    Query.ParamByName('RARITY').Value     := Rarity;

    Query.ExecSQL;
    Query.Free;

    ID := LastPokeId();
    // cria uma fun��o que retoner um inteiro do utimo pokemon, fazendo um select retonando iD
    Erro := '';
    Result := True;
  except
    on E: Exception do
    begin
      Erro := 'Falha ao salvar registro: ' + e.Message;
      Result := False;
    end;
  end;
end;

function TPoke.List(texto: String; out erro: String): TFDQuery;
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

function TPoke.GetIdPoke(id: Integer; out erro: String): TFDQuery;
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
function TPoke.LastPokeId : Integer;
var
  Query: TFDQuery;
begin
  try
    // Cria a query usando a conex�o do banco de dados
    CriarQuery(Query);
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('SELECT MAX(ID) AS ID FROM poke ');
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

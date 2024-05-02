unit Poke;

interface

uses FireDAC.Comp.Client, Data.DB, System.SysUtils, Connection, UtilFunctions;

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

    Query.SQL.Add('INSERT INTO  poke (name, lv, typepoke, rarity) ');
    Query.SQL.Add('VALUES (:NAME, :LV, :TYPEPOKE, :RARITY)        ');

    Query.ParamByName('NAME').Value       := Name;
    Query.ParamByName('LV').Value         := Lv;
    Query.ParamByName('TYPEPOKE').Value   := TypePoke;
    Query.ParamByName('RARITY').Value     := Rarity;

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

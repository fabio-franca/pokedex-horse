unit PokeController;

interface

uses
  Horse, System.Json, System.SysUtils, Poke, Firedac.Comp.Client, Data.DB,
  DataSet.Serialize,Connection;

procedure InsertPoke(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure ListPoke(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetIdPoke(Req: THorseRequest; Res: THorseResponse; Next: TProc);


implementation

procedure InsertPoke(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  poke: TPoke;
  objPoke: TJSONObject;
  erro: string;
  body: TJsonValue;
begin
  try
    poke := TPoke.Create;
  except
    Res.Send('Erro ao conectar com o banco').Status(500);
    Exit;
  end;

  try
    try
      body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Req.Body), 0) As TJsonValue;

      poke.Name := body.GetValue<string>('name', '');
      poke.Lv := body.GetValue<Integer>('lv', 0);
      poke.TypePoke := body.GetValue<string>('typepoke', '');
      poke.Rarity := body.GetValue<string>('rarity', '');

      poke.Insert(erro);

      body.Free;

      if erro <> '' then
        raise Exception.Create(erro);

    except on ex: exception do
      begin
        Res.Send(ex.Message).Status(400);
        exit;
      end;
    end;

    objPoke := TJSONObject.Create;
    objPoke.AddPair('id', Poke.ID.ToString);
    Res.Send<TJSONObject>(objPoke).Status(201)

  finally
    poke.Free;
  end;
end;

procedure ListPoke(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  pokeList: TJSONArray;
  query: TFDQuery;
  poke: TPoke;
  erro: String;
  parametro:  String;

begin

  try
    poke := TPoke.Create;
  except
    Res.Send('Erro ao conectar com o banco').Status(500);
    Exit;
  end;

  parametro := Req.Query.Field('name').AsString;

  query := Poke.List( parametro, erro);

  pokeList := query.ToJSONArray();

  Res.Send<TJsonArray>(pokeList);
end;

procedure GetIdPoke(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  GetIdPoke: TJSONObject;
  query: TFDQuery;
  poke: TPoke;
  erro: String;
  parametro:  Integer;
begin
  try
    poke := TPoke.Create;
  except
    Res.Send('Erro ao conectar com o banco').Status(500);
    Exit;
  end;

  parametro := Req.Params.Items['id'].ToInteger;

  query := Poke.GetIdPoke(parametro, erro);

  if (Query = nil) Then
  begin
    Res.Send('Pokemon n�o encontrado.').Status(400);
  end;

  GetIdPoke := query.ToJSONObject();

  Res.Send<TJSONObject>(GetIdPoke);
end;


end.


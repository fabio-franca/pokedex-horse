unit PokeController;

interface

uses
  Horse, System.Json, System.SysUtils, Poke, Firedac.Comp.Client, Data.DB,
  DataSet.Serialize;

  procedure InsertPoke(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure InsertPoke(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  poke   : TPoke;
  objPoke: TJSONObject;
  erro   : string;
  Body   : TJsonValue;
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

      poke.Name     := body.GetValue<string>('name', '');
      poke.Lv       := body.GetValue<Integer>('lv', 0);
      poke.TypePoke := body.GetValue<string>('typepoke', '');
      poke.Rarity   := body.GetValue<string>('rarity', '');

      poke.Insert(erro);

      body.Free;

      if erro <> '' then
        raise Exception.Create(erro);

    except on ex:exception do
      begin
        Res.Send(ex.Message).Status(400);
        exit;
      end;
    end;

    objPoke := TJSONObject.Create;
    Res.Send<TJSONObject>(objPoke).Status(201)
    {objPoke := TJSONObject.Create;
    objPoke.AddPair('codibair', Bairro.Codibair);

    Res.Send<TJSONObject>(oBairro).Status(201)}
  finally
    poke.Free;
  end;
end;

end.

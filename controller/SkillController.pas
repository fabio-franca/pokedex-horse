unit SkillController;

interface

uses
  Horse, System.Json, System.SysUtils, Poke, Firedac.Comp.Client, Data.DB,
  DataSet.Serialize,Connection, skill;

procedure InsertPokeSkil(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure ListSkill(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetIdSkill(Req: THorseRequest; Res: THorseResponse; Next: TProc);


implementation

procedure InsertPokeSkil(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  skill: TSkill;
  objPoke: TJSONObject;
  erro: string;
  body: TJsonValue;
begin
  try
    skill := TSkill.Create;
  except
    Res.Send('Erro ao conectar com o banco').Status(500);
    Exit;
  end;

  try
    try
      body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Req.Body), 0) As TJsonValue;

      skill.Name := body.GetValue<string>('name', '');
      {poke.Lv := body.GetValue<Integer>('lv', 0);
      poke.TypePoke := body.GetValue<string>('typepoke', '');
      poke.Rarity := body.GetValue<string>('rarity', ''); }

      skill.InsertPokeSkil(erro);

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
    objPoke.AddPair('id', skill.ID.ToString);
    Res.Send<TJSONObject>(objPoke).Status(201)

  finally
    skill.Free;
  end;
end;

procedure ListSkill(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  listSkill: TJSONArray;
  query: TFDQuery;
  skill: TSkill;
  erro: String;
  parametro:  String;

begin

  try
    skill := TSkill.Create;
  except
    Res.Send('Erro ao conectar com o banco').Status(500);
    Exit;
  end;

  parametro := Req.Query.Field('name').AsString;

  query := Skill.ListSkill( parametro, erro);

  listSkill := query.ToJSONArray();

  Res.Send<TJsonArray>(listSkill);
end;

procedure GetIdSkill(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  GetIdSkill: TJSONObject;
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
    Res.Send('Pokemon não encontrado.').Status(400);
  end;

  GetIdSkill := query.ToJSONObject();

  Res.Send<TJSONObject>(GetIdSkill);
end;


end.



//Mesclar a list com GetId e fazer o inset das skil pegando o ID delas

//SKILL: thunder , 4
//skill: fast atack , 4
//skill: pau flamejante, 3
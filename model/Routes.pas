unit Routes;

interface

procedure RoutesApplication;

implementation

uses
  Horse, PokeController, SkillController;

procedure RoutesApplication;
begin
  //Poke
  THorse.Post('/poke/insertPoke', PokeController.InsertPoke);
  THorse.Get('/poke/list', PokeController.ListPoke); // Rota para listar todos os pokemons
  THorse.Get('/poke/:id', PokeController.GetIdPoke); // Rota para obter um poke pelo ID

  //skill
  THorse.Post('/skill/insertPokeSkil', SkillController.InsertPokeSkil);
  THorse.Get('/skill/listSkill', SkillController.ListSkill);
  THorse.Get('/skill/:id', SkillController.GetIdSkill);

end;


end.


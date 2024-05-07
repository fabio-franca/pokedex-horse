program pokedexHorse;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Horse.Jhonson,
  Horse.Etag,
  Poke in 'model\Poke.pas',
  Connection in 'model\Connection.pas',
  UtilFunctions in 'model\UtilFunctions.pas',
  Skill in 'model\Skill.pas',
  PokeController in 'controller\PokeController.pas',
  Routes in 'model\Routes.pas',
  SkillController in 'controller\SkillController.pas';

begin
  THorse.Use(Jhonson())
        .Use(eTag);

  THorse.Routes.Prefix('/pokedex');

  Routes.RoutesApplication;

  THorse.Listen(9000,
                procedure
                begin
                  Writeln(Format('Servidor rodando na porta %d ...', [THorse.Port]));
                  Readln;
                end);
end.

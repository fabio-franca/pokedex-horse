program pokedexHorse;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Poke in 'model\Poke.pas',
  Connection in 'model\Connection.pas',
  UtilFunctions in 'model\UtilFunctions.pas',
  Skill in 'model\Skill.pas';

begin
  THorse.Get('/ping',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send('pong');
    end);

  THorse.Listen(9000);
end.

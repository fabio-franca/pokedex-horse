unit Routes;

interface

  procedure RoutesApplication;

implementation

uses
  Horse, PokeController;

procedure RoutesApplication;
begin
  THorse.Post('/poke/insertPoke', PokeController.InsertPoke);
end;

end.

unit UtilFunctions;

interface

uses
  FireDAC.Comp.Client, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Connection;

  procedure CriarQuery(var AQuery       : TFDQuery);  overload;
  function  Descriptografar(ValStr       : String):    String;
  function  RemoveSpecialChars(const str : string):    string;

implementation

procedure CriarQuery(var AQuery: TFDQuery);
begin
  AQuery            := TFDQuery.Create(nil);
  AQuery.Connection := Connection.Connect;
  AQuery.Close;
  AQuery.SQL.Clear();
end;

function Descriptografar(ValStr: String):String;
Var
  piI      :Integer;
  psResult :String;
begin
  For piI    := 1 To Length(ValStr) Do
    psResult := psResult + Chr(Ord(ValStr[piI])-3);

  Result := psResult;
end;

function RemoveSpecialChars(const str: string): string;
const
  InvalidChars : set of char =
    ['-',' ',',','.','/','!','@','#','$','%','^','&','*','''','"',';','_','(',')',':','|','[',']'];
var
  i, Count: Integer;
begin
  SetLength(Result, Length(str));
  Count := 0;
  for i := 1 to Length(str) do
    if not (str[i] in InvalidChars) then
    begin
      inc(Count);
      Result[Count] := str[i];
    end;
  SetLength(Result, Count);
end;

end.

unit Global.Common.Strings;

interface

uses
  System.Classes, System.SysUtils;

type
  TSetOfChars = set of AnsiChar;

  TStringsUtils = class sealed
  strict private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    class function GUID: TGUID;
    class function GUIDToStr(const pGUID: TGUID): string;
    class function GUIDToStrFormatless(const pGUID: TGUID): string; overload;
    class function GUIDToStrFormatless: string; overload;
    class function GUIDToName(const pPrefix: string): TComponentName;
  end;

implementation

uses
  System.Math, FMX.Platform, Global.Common.DateTime;

{ TStringsUtils }

class function TStringsUtils.GUID: TGUID;
begin
  while (CreateGUID(Result) <> 0) do;
end;

class function TStringsUtils.GUIDToName(const pPrefix: string): TComponentName;
var
  lGUID: string;
begin
  lGUID := GUIDToStrFormatless;
  Result := Format('%s%s', [pPrefix, lGUID]);
end;

class function TStringsUtils.GUIDToStr(const pGUID: TGUID): string;
begin
  Result := GUIDToString(pGUID);
end;

class function TStringsUtils.GUIDToStrFormatless: string;
begin
  Result := GUIDToStrFormatless(GUID);
end;

class function TStringsUtils.GUIDToStrFormatless(const pGUID: TGUID): string;
begin
  SetLength(Result, 32);
  StrLFmt(PChar(Result), 32, '%.8x%.4x%.4x%.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x',   // do not localize
    [pGUID.D1, pGUID.D2, pGUID.D3, pGUID.D4[0], pGUID.D4[1], pGUID.D4[2], pGUID.D4[3],
    pGUID.D4[4], pGUID.D4[5], pGUID.D4[6], pGUID.D4[7]]);
end;

end.

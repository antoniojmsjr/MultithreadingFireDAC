unit InternalHandleException;

interface

uses
  System.SysUtils, FireDAC.Stan.Error, FireDAC.Phys.IBWrapper,
  Horse, Horse.HandleException, Horse.Commons;

procedure InterceptException(const AException: Exception; const ARequest: THorseRequest; const AResponse: THorseResponse; var ASendException: Boolean);

implementation

uses
  System.JSON;

procedure InterceptException(const AException: Exception; const ARequest: THorseRequest; const AResponse: THorseResponse; var ASendException: Boolean);
var
  lCode: Integer;
  lJSON: TJSONObject;
begin
  if (AException is EFDException) then
  begin
    lCode := EFDException(AException).FDCode;

    if (lCode = 708) then
    begin
      ASendException := False;
      lJSON := TJSONObject.Create;
      lJSON.AddPair('mensagem', 'Sistema indisponível, tente mais tarde.');
      AResponse.Send<TJSONObject>(lJSON).Status(THTTPStatus.InternalServerError);
    end
    else
    begin
      ASendException := False;
      lJSON := TJSONObject.Create;
      lJSON.AddPair('erro', Format('Erro: %s - Class: %s', [AException.Message, AException.QualifiedClassName]));
      AResponse.Send<TJSONObject>(lJSON).Status(THTTPStatus.InternalServerError);
    end;
  end;
end;

end.

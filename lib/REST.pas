unit REST;
(*
 *   Copyright (c) 2008 Shintaro Akiyama (freeandnil.self@gmail.com)
 *
 *   Redistribution and use in source and binary forms, with or without
 *   modification, are permitted provided that the following conditions
 *   are met:
 *
 *   1. Redistributions of source code must retain the above copyright
 *      notice, this list of conditions and the following disclaimer.
 *
 *   2. Redistributions in binary form must reproduce the above copyright
 *      notice, this list of conditions and the following disclaimer in the
 *      documentation and/or other materials provided with the distribution.
 *
 *   3. Neither the name of the authors nor the names of its contributors
 *      may be used to endorse or promote products derived from this
 *      software without specific prior written permission.
 *
 *   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 *   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 *   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 *   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 *   OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 *   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 *   TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 *   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 *   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 *   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *)
interface

uses Classes, SysUtils, XMLIntf, XMLDoc, WSDLIntf;

type
  ERESTError = class(Exception);

type
  TRestResponse = class
  private
    FXMLDoc: IXMLDocument;
  protected
    procedure SetResponse(const Response: string);
  public
    constructor Create;
    property Xml: IXMLDocument read FXMLDoc;
  end;

  TRestRequest = class
  private
    FLeft: TWideStrings;
    FRight: TWideStrings;
  protected
    function Get(S: WideString): WideString; virtual;
    procedure Put(Left, Right: WideString); virtual;
  public
    constructor Create;
    destructor Destroy; override;
    property Items[Index: WideString]: WideString read Get write Put; default;
    function Catenate: WideString;
  end;

  TRest = class
  private
    FHost: string;
    FUserAgent: string;
    FOutput: TStrings;
  public
    constructor Create(const Host: string = '');
    procedure Post(const Method: String; const Req: TRestRequest;
       Ret: TRestResponse); virtual;
    procedure Get(const Method: String; const Req: TRestRequest;
        Ret: TRestResponse); virtual;
    property DebugOutput: TStrings read FOutput write FOutput;
    property Host: string read FHost write FHost;
    property UserAgetn: string read FUserAgent write FUserAgent;
  end;


implementation

uses httpsend, xmldom;

{ TRestResponse }

constructor TRestResponse.Create;
begin
  FXMLDoc := TXMLDocument.Create(nil);
end;

procedure TRestResponse.SetResponse(const Response: string);
begin
  FXMLDoc.LoadFromXML(Response);
end;


{ TRestRequest }

function TRestRequest.Catenate: WideString;
var
  i: Integer;
begin
  for i := 0 to FLeft.Count - 1 do begin
    Result := Result + FLeft[i] + '=' + FRight[i];
    if i <> FLeft.Count - 1 then
      Result := Result + '&';
  end;
end;

constructor TRestRequest.Create;
begin
  inherited;
  FLeft := TWideStrings.Create;
  FRight := TWideStrings.Create;
end;

destructor TRestRequest.Destroy;
begin
  FreeAndNil(FLeft);
  FreeAndNil(FRight);
  inherited;
end;

function TRestRequest.Get(S: WideString): WideString;
var
  i: Integer;
begin
  i := FLeft.IndexOf(S);
  if i <> -1 then
    Result := FRight.Strings[i]
  else
    Result := '';
end;

procedure TRestRequest.Put(Left, Right: WideString);
var
  i: Integer;
begin
  i := FLeft.IndexOf(Left);
  if i <> -1 then begin
    FRight.Strings[i] := Right;
  end else begin
    FLeft.Add(Left);
    FRight.Add(Right);
  end;
end;


{ TRest }

procedure CheckError(Http: THTTPSend);
begin
  if Http.ResultCode <> 200 then
    raise ERESTError.CreateFmt('Error Code: %d' + sLineBreak + '%s', [Http.ResultCode, Http.ResultString]);
end;

constructor TRest.Create(const Host: string);
begin
  FHost := Host;
  FOUtput := nil;
end;

procedure TRest.Get(const Method: String;
  const Req: TRestRequest; Ret: TRestResponse);
var
  data: string;
  Buf: string;
  TS: TStringStream;
  Http: THTTPSend;
begin
  TS := TStringStream.Create(Buf);
  try
    if Req <> nil then begin
      Data := UTF8Encode(Req.Catenate);
      if FOutput <> nil then begin
        FOutput.Add('GET ' + Method);
        FOutput.Add(Data);
      end;
    end;
    Http := THTTPSend.Create;
    try
      if FUserAgent <> ''then Http.UserAgent := FUserAgent;

      if Http.HTTPMethod('GET', FHost + Method + '?' + Data) then
        TS.CopyFrom(Http.Document, 0);
      if FOutput <> nil then FOutput.Add(TS.DataString);        
      Ret.SetResponse(TS.DataString);
      CheckError(Http);
    finally
      HTTP.Free;
    end;
  finally
    TS.Free;
  end;
end;

procedure TRest.Post(const Method: String;
  const Req: TRestRequest; Ret: TRestResponse);
var
  Data: string;
  Buf: string;
  TS: TStringStream;
  Http: THTTPSend;
begin
  TS := TStringStream.Create(Buf);
  try
    if Req <> nil then begin
      Data := UTF8Encode(Req.Catenate);
      if FOutput <> nil then begin
        FOutput.Add('POST ' + Method);
        FOutput.Add(Data);
      end;
    end;
    Http := THTTPSend.Create;
    try

      Http.Document.Write(PChar(Data)^, Length(Data));
      HTTP.MimeType := 'application/x-www-form-urlencoded';
      if FUserAgent <> '' then Http.UserAgent := FUserAgent;

      if Http.HTTPMethod('POST', FHost + Method) then
        TS.CopyFrom(HTTP.Document, 0);
      if FOutput <> nil then FOutput.Add(TS.DataString);
      CheckError(Http);
      Ret.SetResponse(TS.DataString);
    finally
      Http.Free;
    end;
  finally
    TS.Free;
  end;
end;

end.


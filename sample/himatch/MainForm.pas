unit MainForm;
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

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, REST, OleCtrls, SHDocVw;

type
  THimatchRest = class(TRest)
  public
    procedure Get(const Method: String; const Req: TRestRequest;
       Ret: TRestResponse); override;  
  end;

  TForm1 = class(TForm)
    Panel1: TPanel;
    Label3: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    ComboBox1: TComboBox;
    Button1: TButton;
    Panel2: TPanel;
    UpDown1: TUpDown;
    Panel3: TPanel;
    lblCount: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    edtUserId: TEdit;
    edtUserName: TEdit;
    edtDistance: TEdit;
    edtAreaName: TEdit;
    edtLat: TEdit;
    edtLon: TEdit;
    edtPostTime: TEdit;
    edtHimaTime: TEdit;
    edtCommentCount: TEdit;
    edtUrl: TEdit;
    Label13: TLabel;
    Panel4: TPanel;
    WebBrowser1: TWebBrowser;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure Button2Click(Sender: TObject);
  private
    { Private éŒ¾ }
  public
    { Public éŒ¾ }
    PageNo: Integer;
    MaxPageNo: Integer;
    Response: TRestResponse;
    procedure Display(No: Integer);
    procedure GetHimatch(NewPageNo: Integer);
    procedure ShowURLImage(const Url: String);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses XMLIntf;

const PAGE_COUNT = 10;

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  MaxPageNo := -1;
  UpDown1.Position := 0;
  GetHimatch(1);
  Display(0);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if edtUrl.Text = '' then Exit;
  WebBrowser1.Navigate(edtUrl.Text, navOpenInNewWindow);
end;

procedure TForm1.Display(No: Integer);
var
  Root, Item: IXMLNode;
  Accum: Integer;
begin
  if Response = nil then Exit;

  Accum := PAGE_COUNT * PageNo;

  if No > Accum then begin
     GetHimatch(PageNo + 1);
  end else if No < Accum - PAGE_COUNT then begin
    GetHimatch(PageNo - 1);
  end;
  Root := Response.Xml.DocumentElement;
  Item := Root.ChildNodes.FindSibling(Root.ChildNodes['Item'], No mod PAGE_COUNT);
  if Item = nil then Exit;

  lblCount.Caption := IntToStr(No+1) + ' / ' + Root.ChildNodes['Count'].Text;
  edtUserId.Text := Item.ChildNodes['UserId'].Text;
  edtUserName.Text := Item.ChildNodes['UserName'].Text;
  edtDistance.Text := Item.ChildNodes['Distance'].Text;
  edtAreaName.Text := Item.ChildNodes['AreaName'].Text;
  edtLat.Text := Item.ChildNodes['Latitude'].Text;
  edtLon.Text := Item.ChildNodes['Longitude'].Text;
  edtPostTime.Text := Item.ChildNodes['PostTime'].Text;
  edtHimaTime.Text := Item.ChildNodes['HimaTime'].Text;
  edtCommentCount.Text := Item.ChildNodes['CommentCount'].Text;
  edtUrl.Text := Item.ChildNodes['Url'].Text;
  ShowURLImage(Item.ChildNodes['UserPic'].Text);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Response := nil;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Response);
end;

procedure TForm1.GetHimatch(NewPageNo: Integer);
var
  Data: TRestRequest;
  Rest: THimatchRest;
begin
  if Edit1.Text = '' then Exit;
  if Edit2.Text = '' then Exit;
  if ComboBox1.ItemIndex < 0 then Exit;
  if (MaxPageNo > -1) and (PageNo > MaxPageNo) then Exit;
  if PageNo < 0 then Exit;

  Screen.Cursor := crHourGlass;
  Data := nil;
  Rest := nil;
  if Response <> nil then FreeAndNil(Response);
  try
    Rest := THimatchRest.Create('http://himatch.net/api/');
    Data := TRestRequest.Create;
    Response := TRestResponse.Create;
    Data['key'] := 'guest';
    Data['lat'] := Edit1.Text;
    Data['lon'] := Edit2.Text;
    Data['time'] := ComboBox1.Text;
    Data['page'] := IntToStr(NewPageNo);
    Rest.Get('', Data, Response);
    PageNo := NewPageNo;
    MaxPageNo := StrToInt(Response.Xml.DocumentElement.ChildNodes['TotalPages'].Text);
  finally
    Screen.Cursor := crDefault;
    Data.Free;
    Rest.Free;
  end;
end;

procedure TForm1.ShowURLImage(const Url: String);
begin
  WebBrowser1.Navigate(Url);
end;

procedure TForm1.UpDown1Click(Sender: TObject; Button: TUDBtnType);
begin
  Screen.Cursor := crHourGlass;
  try
  Display(UpDown1.Position);
  finally
    Screen.Cursor := crDefault;
  end;
end;

{ THimatchRest }

procedure THimatchRest.Get(const Method: String; const Req: TRestRequest;
  Ret: TRestResponse);
var
  code, msg: string;
begin
  inherited;
  if Ret.Xml.DocumentElement.ChildNodes.FindNode('Error') <> nil then begin
    code := Ret.Xml.DocumentElement.ChildNodes['Error'].Text ;
    msg := Ret.Xml.DocumentElement.ChildNodes['Message'].Text;
    raise ERESTError.CreateFmt('Error Code: %s' + sLineBreak + '%s', [code, Msg]);
  end;
end;

end.

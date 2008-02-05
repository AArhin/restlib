unit main;
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
  Dialogs, StdCtrls, REST, ComCtrls, ExtCtrls;

type
  TMainForm = class(TForm)
    TreeView1: TTreeView;
    Panel1: TPanel;
    ComboBox1: TComboBox;
    Button1: TButton;
    ComboBox2: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses XMLIntf, XMLDoc;

procedure MapToTreeView(Xml: IXMLNode; View: TTreeView; Parent: TTreeNode);
var
  i: Integer;
  Node: TTreeNode;
  s: string;
begin
  for i := 0 to Xml.AttributeNodes.Count - 1 do  begin
    s := s + Xml.AttributeNodes[i].NodeName + '=' + Xml.AttributeNodes[i].Text + ' ';
  end;
  Node := View.Items.AddChild(Parent, Xml.NodeName + ' ' + s);

  if Xml.IsTextElement then begin
    View.Items.AddChild(Node, Xml.Text);
    Exit;
  end;

  for i := 0 to Xml.ChildNodes.Count - 1 do begin
    MapToTreeView(Xml.ChildNodes[i], View, Node);
  end;
end;

procedure TMainForm.Button1Click(Sender: TObject);
var
  Rest: TRest;
  Ret: TRestResponse;
  Param: TRestRequest;
begin
  if ComboBox1.ItemIndex < 0 then Exit;
  if ComboBox2.ItemIndex < 0 then Exit;

  Rest := nil;
  Ret := nil;
  Param := nil;
  try
    Rest := TRest.Create('http://weather.livedoor.com/forecast/webservice/rest/v1');
    Ret := TRestResponse.Create;
    Param := TRestRequest.Create;
    Param['city'] := IntToStr(Integer(ComboBox1.Items.Objects[ComboBox1.ItemIndex]));
    Param['day'] := ComboBox2.Text;
    Rest.Get('', Param, Ret);

    LockWindowUpdate(TreeView1.Handle);
    try
      TreeView1.Items.Clear;
      MapToTreeView(Ret.Xml.DocumentElement, TreeView1, nil);
      TreeView1.FullExpand;
      TreeView1.TopItem := TreeView1.Items[0];
    finally
      LockWindowUpdate(0);
    end;
  finally
    Param.Free;
    Ret.Free;
    Rest.Free;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  xml: IXMLDocument;
  source, pref: IXMLNodeList;
  i, j, k: Integer;
  Id: Integer;
begin
  xml := TXMLDocument.Create('forecastmap.xml');
  xml.Active := True;

  source := xml.DocumentElement.ChildNodes['channel'].
      ChildNodes['ldWeather:source'].ChildNodes;

  for i := 0 to source.Count - 1 do begin
    if source[i].HasChildNodes then begin
      for j := 0 to source[i].ChildNodes.Count - 1 do begin
        if source[i].ChildNodes[j].HasChildNodes then begin
          pref := source[i].ChildNodes[j].ChildNodes;
          for k := 0 to pref.Count - 1 do begin
            if pref[k].NodeName = 'city' then begin
              Id := StrToInt(pref[k].Attributes['id']);
              Combobox1.AddItem(pref[k].Attributes['title'], Pointer(Id));
            end;
          end;
        end;
      end;
    end;
  end;
  ComboBox1.ItemIndex := 0;
end;

end.

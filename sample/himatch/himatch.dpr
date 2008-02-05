program himatch;

uses
  Forms,
  MainForm in 'MainForm.pas' {Form1},
  REST in '..\..\lib\REST.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

program livedoorweather;

uses
  Forms,
  main in 'main.pas' {MainForm},
  REST in '..\..\lib\REST.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

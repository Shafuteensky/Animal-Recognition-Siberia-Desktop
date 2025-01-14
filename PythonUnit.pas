unit PythonUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  PythonVersions, PythonEngine, Vcl.PythonGUIInputOutput, System.JSON;

type
  TPython = class(TForm)
    PythonEngine: TPythonEngine;
    PythonModule: TPythonModule;
    Preparation: TMemo;
    Recognition: TMemo;
    JsonStringPyVar: TPythonDelphiVar;
    Label1: TLabel;
    Label2: TLabel;
    GetExifJson: TMemo;
    SetExifJson: TMemo;
    Label3: TLabel;
    Label4: TLabel;
    AnimalClassPyVar: TPythonDelphiVar;
    ObjectBoxPyVar: TPythonDelphiVar;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    procedure MarkNewObject(path: string);
    procedure SetJsonExif(imagePath: String; jsonString: String);
    function GetJsonExif(imagePath: String): string;
    procedure PreparePython;
    procedure AnimalClassPyVarSetData(Sender: TObject; Data: Variant);
    procedure AnimalClassPyVarGetData(Sender: TObject; var Data: Variant);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Python: TPython;

implementation

uses
  FunctionsUnit, MainUnit, LoadingUnit;

{$R *.dfm}

procedure TPython.PreparePython;
begin
  AppPath := IncludeTrailingPathDelimiter(ExtractFileDir(Application.ExeName));
  try
    MaskFPUExceptions(True); // Святая функция
    FreeAndNil(PythonEngine);
    PythonEngine.Free;
    PythonEngine := TPythonEngine.Create(nil);
    PythonEngine.AutoFinalize := True;
    PythonEngine.UseLastKnownVersion := False;
    PythonEngine.RegVersion := '3.9';
    PythonEngine.APIVersion := 1013;
    PythonEngine.DllName := 'python39.dll';
    PythonEngine.DllPath := AppPath+'python\';
    PythonEngine.LoadDll;
    PythonModule.Engine := PythonEngine;
    PythonModule.Initialize;
    PythonModule.SetVarFromVariant('appPath', AppPath);
    PythonEngine.ExecStrings(Preparation.Lines);
    JsonStringPyVar.Engine := PythonEngine;
    JsonStringPyVar.Initialize;
    LoadingForm.Close;
  except
    Functions.MyMessageDlg('Ошибка инициализации Python.' + #13#10 + 'Обработчик будет недоступен.',
      mtError, [mbYes], ['ОК'], 'Ошибка');
    Main.OpenProcessor.Enabled := False;
  end;
end;

procedure TPython.AnimalClassPyVarGetData(Sender: TObject;
  var Data: Variant);
begin

  Functions.MyMessageDlg('Amogus', mtWarning, [mbOk], ['Amogus'], 'Amogus');
end;

procedure TPython.AnimalClassPyVarSetData(Sender: TObject; Data: Variant);
begin
  Functions.MyMessageDlg('Amogus', mtWarning, [mbOk], ['Amogus'], 'Amogus');
end;

procedure TPython.FormCreate(Sender: TObject);
begin
//  LoadingForm.Show;
//  Python.PreparePython;
//  LoadingForm.Close;
end;

procedure TPython.FormDestroy(Sender: TObject);
begin
  PythonModule.Finalize;
  FreeAndNil(PythonEngine);
  FreeAndNil(PythonModule);
end;

procedure TPython.MarkNewObject(path: string);
begin
  PythonModule.SetVarFromVariant('imagePath', path);
  PythonEngine.ExecStrings(Recognition.Lines);
end;

procedure TPython.SetJsonExif(imagePath: String; jsonString: String);
begin
  PythonModule.SetVarFromVariant('imagePath', imagePath);
  PythonModule.SetVarFromVariant('jsonString', jsonString);
  PythonEngine.ExecStrings(SetExifJson.Lines);
end;

function TPython.GetJsonExif(imagePath: String): string;
var
  JsonString: String;
begin
  PythonModule.SetVarFromVariant('imagePath', imagePath);
  PythonEngine.ExecStrings(GetExifJson.Lines);
  JsonString := JsonStringPyVar.ValueAsString;
  JsonString := StringReplace(JsonString, #39, #34, [rfReplaceAll, rfIgnoreCase]);
  Result := JsonString;
end;

end.

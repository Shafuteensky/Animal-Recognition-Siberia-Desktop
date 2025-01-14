unit SettingsUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Registry, shlobj, iniFiles;

type
  TSettings = class(TForm)
    GroupBox2: TGroupBox;
    GridPanel1: TGridPanel;
    Label2: TLabel;
    NeuralConfidence: TEdit;
    SaveSettingsButton: TButton;
    Compression: TRadioGroup;
    GroupBox1: TGroupBox;
    HideBoxesOnMouseEnter: TCheckBox;
    GroupBox3: TGroupBox;
    GridPanel4: TGridPanel;
    SortPathEdit: TEdit;
    ChooseSortFolderButton: TButton;
    UseDefaultCatalog: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure LoadSettings();
    procedure SaveSettings;
    procedure CompressionClick(Sender: TObject);
    procedure SaveSettingsButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ChooseSortFolderButtonClick(Sender: TObject);
    procedure UseDefaultCatalogClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Settings: TSettings;
  SettingsFileNotFound: Boolean;
  SortingCatalog: string;
const
  setCfg = '\settings.cfg';

implementation

uses
  FunctionsUnit, MainUnit;

{$R *.dfm}

procedure TSettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if SaveSettingsButton.Enabled then
    LoadSettings();
end;

procedure TSettings.FormCreate(Sender: TObject);
var
  text : TextFile;
  i: integer;
begin
  LoadSettings();
end;

procedure TSettings.FormShow(Sender: TObject);
begin
  SortPathEdit.Text := SortingCatalog;
  SaveSettingsButton.Enabled := False;
end;

procedure TSettings.LoadSettings();
var
  ini: TIniFile;
begin
  SettingsFileNotFound := False;
  if not FileExists(ExtractFileDir(ParamStr(0))+setCfg) then
  begin
    SettingsFileNotFound := True;
  end;

  ini := TIniFile.Create(ExtractFileDir(ParamStr(0))+setCfg);
  with ini do
  begin
    HideBoxesOnMouseEnter.Checked := ReadBool('Image', 'HideBoxes', True);
    Compression.ItemIndex := ReadInteger('Image', 'Compression', 0);
    NeuralConfidence.Text := IntToStr(ReadInteger('NeuralNet', 'Confidence', 70));
    UseDefaultCatalog.Checked := ReadBool('Catalog', 'UseDefault', True);
    SortingCatalog := ReadString('Catalog', 'SortingDirectory', AppPath+baseImageFolder);
    SortPathEdit.Text := SortingCatalog;
    Free;
  end;
end;

procedure TSettings.SaveSettings;
var
  ini: TIniFile;
  procedure resetCatalog;
  begin
    SortingCatalog := AppPath+baseImageFolder;
    SortPathEdit.Text := SortingCatalog;
    UseDefaultCatalog.Checked := True;
  end;
begin
  ini := TIniFile.Create(ExtractFileDir(ParamStr(0))+setCfg);
  if UseDefaultCatalog.Checked then resetCatalog
  else
  begin
    if DirectoryExists(SortPathEdit.Text) then
      SortingCatalog := SortPathEdit.Text
    else
    begin
      Functions.MyMessageDlg('Выбранной каталог сортировки не существует!'+#13#10+
        'Каталог был изменен на стандартный.', mtWarning, [mbYes], ['ОК'], 'Уведомление');
      resetCatalog;
    end;
  end;
  with ini do
  begin
    WriteBool('Image', 'HideBoxes', HideBoxesOnMouseEnter.Checked);
    WriteInteger('Image', 'Compression', Compression.ItemIndex);
    WriteInteger('NeuralNet', 'Confidence', StrToInt(NeuralConfidence.Text));
    WriteBool('Catalog', 'UseDefault', UseDefaultCatalog.Checked);
    WriteString('Catalog', 'SortingDirectory', SortingCatalog);
    Free;
  end;
end;

procedure TSettings.CompressionClick(Sender: TObject);
begin
  SaveSettingsButton.Enabled := True;
end;

procedure TSettings.UseDefaultCatalogClick(Sender: TObject);
begin
  SaveSettingsButton.Enabled := True;
  SortPathEdit.Enabled := not UseDefaultCatalog.Checked;
  ChooseSortFolderButton.Enabled := not UseDefaultCatalog.Checked;
end;

procedure TSettings.ChooseSortFolderButtonClick(Sender: TObject);
begin
  with TFileOpenDialog.Create(nil) do
  begin
    Options := [fdoPickFolders, fdoPathMustExist, fdoForceFileSystem];
    if Execute then
    begin
      SortingCatalog := SortPathEdit.Text;
      SortPathEdit.Text := FileName;
      SaveSettingsButton.Enabled := True;
    end;
    Free;
  end;
end;

procedure TSettings.SaveSettingsButtonClick(Sender: TObject);
begin
  SaveSettings;
  SaveSettingsButton.Enabled := False;
end;

end.

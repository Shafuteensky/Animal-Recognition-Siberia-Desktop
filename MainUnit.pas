unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Menus, System.Math,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids,
  Vcl.ComCtrls, Vcl.DBCtrls, Vcl.FileCtrl, Vcl.Outline, Vcl.Samples.DirOutln,
  Vcl.CheckLst, Vcl.Mask, System.JSON, System.IOUtils, System.StrUtils, System.Types,
  Vcl.Imaging.jpeg, Vcl.Graphics;

type
  TListBox = class(Vcl.StdCtrls.TListBox)
    function DoMouseWheel(_Shift: TShiftState; _WheelDelta: Integer; _MousePos: TPoint): Boolean; override;
  end;
  TCustomGridHelper = class helper for TCustomGrid
  public
    procedure DelRow(ARow: Integer);
  end;
  TDictConstant = array[0..3, 0..1] of String;
  CyrillicString = type AnsiString(1251);
  TMain = class(TForm)
    MainMenu1: TMainMenu;
    OpenProcessor: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    OpenImageInShellView: TMenuItem;
    N9: TMenuItem;
    SaveReportCSV: TMenuItem;
    Timer1: TTimer;
    LeftPanel: TPanel;
    FilesPanel: TPanel;
    Label8: TLabel;
    GridPanel2: TGridPanel;
    Label4: TLabel;
    TotalImagesLabel: TLabel;
    Label5: TLabel;
    ProcImagesLabel: TLabel;
    Label6: TLabel;
    InfoImagesLabel: TLabel;
    Label7: TLabel;
    NProcImagesLabel: TLabel;
    GridPanel4: TGridPanel;
    FolderPathEdit: TEdit;
    OpenFolderButton: TButton;
    ImagePreviewPanel: TPanel;
    ImagePreviewNameLabel: TLabel;
    ImagePreviewDateLabel: TLabel;
    ImagePreviewObjectsList: TListBox;
    Panel1: TPanel;
    ImagePreview: TImage;
    ImagesListBox: TListBox;
    CenterPanel: TPanel;
    BottomPanel: TPanel;
    FillPanel2: TPanel;
    ProcessingPanel: TPanel;
    ScrollBox1: TScrollBox;
    ImageNameLabel: TLabel;
    ImageObjectsLabel: TLabel;
    Label1: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    InfoPanel: TGridPanel;
    Label16: TLabel;
    ImageDateLabel: TLabel;
    ProcessBottomPanel: TPanel;
    ObjectsGrid: TStringGrid;
    ObjectClassGroup: TGroupBox;
    CurrentObjClassLabel: TLabel;
    Label3: TLabel;
    CancelChangingButton: TButton;
    ApplyChangingButton: TButton;
    AnimalClassesCB: TComboBox;
    ObjectGroup: TPanel;
    Bevel1: TBevel;
    MarkObjectButton: TButton;
    ChangeClassButton: TButton;
    DeleteObjButton: TButton;
    MarkNewFirstObjectButton: TButton;
    ImagePanel: TPanel;
    Label10: TLabel;
    ImageBottomPanel: TGridPanel;
    PrevImageButton: TButton;
    NextImageButton: TButton;
    ImageScaleTrackBar: TTrackBar;
    AllowImageResize: TCheckBox;
    Image1: TImage;
    MainImageScrollBox: TScrollBox;
    MainImage: TImage;
    AutoProcMenuButton: TMenuItem;
    LoadingLabel: TLabel;
    Label12: TLabel;
    PhotoDateLabel: TLabel;
    ChangePhotoDate: TButton;
    ParametersPanel: TPanel;
    DoNeuro: TCheckBox;
    SortToClassFolders: TCheckBox;
    SortDates: TCheckBox;
    FirstDates: TRadioButton;
    FirstClasses: TRadioButton;
    CopyNonInformative: TCheckBox;
    ProcessFolderButton: TButton;
    ProcessingProgressBar: TProgressBar;
    GridPanel5: TGridPanel;
    FoldProcessing: TCheckBox;
    GridPanel1: TGridPanel;
    FoldPreview: TCheckBox;
    Label13: TLabel;
    Label9: TLabel;
    NonBinarySeparation: TCheckBox;
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure OpenFolderButtonClick(Sender: TObject);
    procedure AllowImageResizeClick(Sender: TObject);
    procedure mainImageResize;
    procedure ImageScaleTrackBarChange(Sender: TObject);
    procedure ApplyChangingButtonClick(Sender: TObject);
    procedure CancelChangingButtonClick(Sender: TObject);
    procedure ChangeClassButtonClick(Sender: TObject);
    procedure DeleteObjButtonClick(Sender: TObject);
    procedure UpdateInterface;
    procedure ResetEditingUI;
    procedure NextImageButtonClick(Sender: TObject);
    procedure PrevImageButtonClick(Sender: TObject);
    procedure ObjectsGridClick(Sender: TObject);
    procedure ObjectsGridMouseEnter(Sender: TObject);
    procedure OpenImageInShellViewClick(Sender: TObject);
    procedure SaveReportCSVClick(Sender: TObject);
    procedure MainImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MainImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MainImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MarkObjectButtonClick(Sender: TObject);
    procedure MainImageMouseEnter(Sender: TObject);
    procedure MainImageMouseLeave(Sender: TObject);

    function ClientToTImage(const P: TPoint): TPoint;
    procedure ProcessFolderButtonClick(Sender: TObject);
    procedure CheckProcVars;
    procedure DoNeuroClick(Sender: TObject);
    procedure ChangeFolderButtonClick(Sender: TObject);
    procedure ImagesListBoxClick(Sender: TObject);
    procedure ImagesListBoxDblClick(Sender: TObject);
    procedure ImagesListBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ImagesListBoxMouseEnter(Sender: TObject);
    procedure AutoFindButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ChangePhotoDateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FoldProcessingClick(Sender: TObject);
    procedure FoldPreviewClick(Sender: TObject);
    procedure Label13Click(Sender: TObject);
    procedure Label9Click(Sender: TObject);

  private
    PythonLoaded: Boolean;
    ActiveImagePath: String;
    FolderPath: String;
    IsImageSelected: Boolean;
    IsFolderSelected: Boolean;
    IsObjectsExists: Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Main: TMain;
  AppPath: string;
const
  baseImageFolder = 'images\';

implementation

uses
  Generics.Collections, AboutUnit, FunctionsUnit, HelpUnit, LoadingUnit,
  PythonUnit, SettingsUnit, ShellApi, AnimalsObjectsUnit, DateUtils, CCR.Exif,
  Winapi.Commctrl;

{$R *.dfm}

// Форма ================================================

procedure TMain.FormCreate(Sender: TObject);
begin
  AppPath := ExtractFilePath(ParamStr(0));
end;

procedure TMain.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  LoadingForm.Close;
  if not PythonLoaded then
  begin
    Python.PreparePython;
    PythonLoaded := True;
  end;
  if SettingsFileNotFound then
  begin
    Functions.MyMessageDlg('Файл настроек не найден.' + #13#10 + 'Будут загружены стандартные настройки.',
      mtWarning , [mbYes], ['Ок'], 'Предупреждение');
    SettingsFileNotFound := False;
    Settings.SaveSettings;
  end;
  // UI
  with ObjectsGrid do
  begin
    FixedRows := 1;
    Cells[0, 0] := '№';
    ColWidths[0] := 25;
    Cells[1, 0] := 'Объект';
    ColWidths[1] := 150;
    Cells[2, 0] := 'Точность';
    ColWidths[2] := 80;
    Cells[3, 0] := 'Координаты';
    ColWidths[3] := 170;
    RowCount := 2;
  end;
end;

// Каталог ================================================

// Редактирование ================================================

// Меню ================================================

procedure TMain.OpenImageInShellViewClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar(ActiveImagePath), nil, nil, SW_SHOWNORMAL);
end;

procedure TMain.SaveReportCSVClick(Sender: TObject);
var
  LeBookmark: TBookmark;
  Stream: TFileStream;
  i: Integer;
  OutLine: string;
  sTemp: string;
  CyrillicText: CyrillicString;
begin
  if not DirectoryExists(PWideChar(WideString(AppPath+'reports\'))) then
    CreateDir(PWideChar(WideString(AppPath+'reports\')));
  Stream := TFileStream.Create(AppPath+'reports\'+DateToStr(Now)+'_'+
    StringReplace(TimeToStr(Now), ':', '.', [rfReplaceAll, rfIgnoreCase])+'.csv', fmCreate);
  try

  finally
    Functions.MyMessageDlg('Отчет успешно сохранен в'+#13#10+
      'папке \reports!', mtInformation, [mbYes], ['ОК'], 'Уведомление');
    Stream.Free;  // Saves the file
  end;
end;

procedure TMain.N2Click(Sender: TObject);
begin
  Settings.ShowModal();
end;

procedure TMain.N3Click(Sender: TObject);
begin
  Help.Show();
  Help.Help.ActivePageIndex := 0;
end;

procedure TMain.N4Click(Sender: TObject);
begin
  About.Show();
end;

procedure TMain.N5Click(Sender: TObject);
begin
  if Functions.MyMessageDlg('Выйти из программы?',
    mtConfirmation, [mbYes, mbNo], ['Выход', 'Отмена'], 'Подтверждение') = mrYes then
      Application.Terminate;
end;

// Изображение ================================================

// Объекты ================================================



// Вспомогательные ================================================================================

function TListBox.DoMouseWheel(_Shift: TShiftState; _WheelDelta: Integer; _MousePos: TPoint): Boolean;
var
  Idx: Integer;
begin
  Idx := ItemIndex - Sign(_WheelDelta);
  if Idx >= Items.Count then
    Idx := Items.Count
  else if Idx < 0 then
    Idx := 0;
  ItemIndex := Idx;
  Self.Click;
  Result := True;
end;

procedure TCustomGridHelper.DelRow(ARow: Integer);
begin
  Self.DeleteRow(ARow);
end;

// Функции ================================================================================

function TMain.ClientToTImage(const P: TPoint): TPoint;
var
  cW, cH: Integer;       // width and height of control
  bW, bH: Integer;       // width and height of bitmap
  Origin: TPointF;       // top-left pixel of bitmap in the control
  ZoomW, ZoomH: Double;  // required zoom factor to make bitmap fit horisontally or vertically
  Zoom: Double;          // zoom factor
begin
  cW := MainImage.Width;
  cH := MainImage.Height;
  bW := MainImage.Picture.Bitmap.Width;
  bH := MainImage.Picture.Bitmap.Height;

  ZoomW := cW/bW;
  ZoomH := cH/bH;
  Zoom := Min(ZoomW, ZoomH);

  Origin.X := (cW - bW*Zoom) / 2;
  Origin.Y := (cH - bH*Zoom) / 2;

  Result.X := Floor((P.X - Origin.X) / Zoom);
  Result.Y := Floor((P.Y - Origin.Y) / Zoom);
end;

procedure TMain.ResetEditingUI;
begin
  if ObjectClassGroup.Visible then CancelChangingButton.Click;
end;

procedure TMain.UpdateInterface;
begin
  if (DoNeuro.Checked or SortToClassFolders.Checked) and IsFolderSelected then
  begin
    AutoProcMenuButton.Enabled := True;
    ImagePreviewPanel.Visible := True;
    ImageBottomPanel.Visible := True;
    ProcessFolderButton.Enabled := True;
    OpenImageInShellView.Enabled := True;
  end
  else
  begin
    AutoProcMenuButton.Enabled := False;
    ImagePreviewPanel.Visible := False;
    ImageBottomPanel.Visible := False;
    ProcessFolderButton.Enabled := False;
    OpenImageInShellView.Enabled := False;
  end;

  if IsImageSelected then
  begin
    ProcessingPanel.Visible := True;
  end
  else
  begin
    ProcessingPanel.Visible := False;
  end;

  if IsObjectsExists then
  begin
    ChangeClassButton.Enabled := True;
    DeleteObjButton.Enabled := True;
  end
  else
  begin
    ChangeClassButton.Enabled := False;
    DeleteObjButton.Enabled := False;
  end;
end;

procedure TMain.mainImageResize;
begin
  if not AllowImageResize.Checked then
  begin
    MainImage.Align := alClient;
  end
  else
  begin
    MainImage.Align := alNone;
    MainImage.Width := round(MainImage.Picture.Width*(ImageScaleTrackBar.Position));
    MainImage.Height := round(MainImage.Picture.Height*(ImageScaleTrackBar.Position));
  end;
end;

// Форма ================================================================================

procedure TMain.FormResize(Sender: TObject);
begin
  mainImageResize;
end;

procedure TMain.FormShow(Sender: TObject);
begin
  LoadingForm.ShowModal;
  Timer1.Enabled := True;
//  Processor.AutoSize := False;
//  Processor.AutoSize := True;
// UI
  Objects.EndMarkingNewObject(Main);
end;

procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Objects.EndMarkingNewObject(Main);
end;

procedure TMain.FoldProcessingClick(Sender: TObject);
begin
  if FoldProcessing.Checked then
  begin
    ParametersPanel.AutoSize := True;
  end
  else
  begin
    ParametersPanel.AutoSize := False;
    ParametersPanel.Height := 32;
  end;
end;

procedure TMain.Label13Click(Sender: TObject);
begin
  FoldProcessing.Checked := not FoldProcessing.Checked;
end;

procedure TMain.FoldPreviewClick(Sender: TObject);
begin
  if FoldPreview.Checked then
  begin
    ImagePreviewPanel.AutoSize := True;
  end
  else
  begin
    ImagePreviewPanel.AutoSize := False;
    ImagePreviewPanel.Height := 32;
  end;
end;

procedure TMain.Label9Click(Sender: TObject);
begin
  FoldPreview.Checked := not FoldPreview.Checked;
end;

// Каталог ================================================================================

// Проверяет по имени, если ли изображение в базе, если есть - сравнивает, похоже ли, если да
// дает False, нет - дает новое имя, заново проверяет по нему, если похожего так и не было
// возвращает True и новое имя
//function TMain.IsAlreadyInBase(imagePath: string): Boolean;
//var
//  k, i, j: integer;
//  SsearchRecord: TSearchRec;
//  fileName: string;
//  originalFileName: string;
//  fileExt: string;
//  jpgImage1: TJPEGImage;
//  jpgImage2: TJPEGImage;
//  originalImage: TBItmap;
//  storedImage: TBItmap;
//  simPixs: integer;
//  jpegLoaded: Boolean;
//  fileExist: Boolean;
//const
//  convSize = 56;
//begin
//  fileExist := False;
//  jpegLoaded := False;
//  fileName := Tpath.GetFileName(imagePath);
//  originalFileName := TPath.GetFileNameWithoutExtension(fileName);
//  fileExt := TPath.GetExtension(imagePath);
//  k := 1;
//
//  while FileExists(AppPath + baseImeageDir + fileName) do
//  begin
//    if not jpegLoaded then
//    begin
//      jpgImage1 := TJpegImage.Create;
//      jpgImage1.LoadFromFile(imagePath);
//      originalImage := Tbitmap.Create;
//      originalImage.Width := convSize;
//      originalImage.Height := convSize;
//      originalImage.Canvas.StretchDraw(originalImage.Canvas.Cliprect, jpgImage1);
//      jpegLoaded := True;
//    end;
//
//    jpgImage2 := TJpegImage.Create;
//    jpgImage2.LoadFromFile(AppPath + baseImeageDir + fileName);
//    storedImage := Tbitmap.Create;
//    storedImage.Width := convSize;
//    storedImage.Height := convSize;
//    storedImage.Canvas.StretchDraw(storedImage.Canvas.Cliprect, jpgImage2);
//
//    simPixs := 0;
//    for i:=1 to convSize do
//      for j:=1 to convSize do
//        if originalImage.Canvas.pixels[i,j] = storedImage.Canvas.pixels[i,j] then
//        begin
//          simPixs := simPixs + 1;
//        end;
//    if simPixs = (convSize*convSize) then
//    begin
//      fileExist := True;
//    end;
//
//    fileName := originalFileName+' ('+IntToStr(k)+')'+fileExt;
//    k := k + 1;
//  end;
//  newImageName := fileName;
//  Result := fileExist;
//end;

procedure TMain.ProcessFolderButtonClick(Sender: TObject);
var
  SsearchRecord: TSearchRec;
  imageFullPath: string;
  ExifData: TExifData;
  JSONData: string;
  JSonObject: TJSonObject;
  ImageJson: TJSonValue;
  Animals: TJSONArray;
  Animal: TJSonValue;
  ObjClass: string;
  uniqueAnimalsList: TList<string>;
  uniqueAnimal: string;
  uniqueAnimalsString: string;
  imagesStatesCounter: IntegerArray;
  Start, Stop: TDateTime;
  Elapsed: int64;
  ProgressBarLabel: TLabel;
  FirstAnimalClass: string;
  DestPath: string;
  DestImagePath: string;
  ProcessDateStr: string;
  ProcessFailure: boolean;
  ImageShotDate: string;
begin
  if Functions.MyMessageDlg('Обработать с текущими настройками?',
    mtCustom, [mbYes, mbNo], ['Да', 'Отмена'], 'Подтверждение') <> mrYes then exit;
  ProcessFailure := False;
  ImagePanel.Visible := False;
  LoadingLabel.Caption := 'ОБРАБОТКА';
  if not DirectoryExists(PWideChar(WideString(AppPath+baseImageFolder))) then
    CreateDir(PWideChar(WideString(AppPath+baseImageFolder)));
  try
    Start := Now;
    ProcessFolderButton.Visible := False;
    ProcessingProgressBar.Max := StrToInt(TotalImagesLabel.Caption);
    ProcessingProgressBar.Visible := True;
    ProcessingProgressBar.Position := 0;
    ProgressBarLabel := TLabel.Create(nil);
    Main.Enabled := False;
    with ProgressBarLabel do
    begin
      Parent := ProcessingProgressBar;
      AutoSize := False;
      Transparent := True;
      Top :=  0;
      Left :=  0;
      Width := ProcessingProgressBar.ClientWidth;
      Height := ProcessingProgressBar.ClientHeight;
      Alignment := taCenter;
      Layout := tlCenter;
      Caption := 'Расчет...';
    end;

    if not DirectoryExists(SortingCatalog) then
    begin
      Functions.MyMessageDlg('Выбранной каталог сортировки не существует!'+#13#10+
        'Каталог был изменен на стандартный.', mtWarning, [mbYes], ['ОК'], 'Уведомление');
      SortingCatalog := AppPath+baseImageFolder;
    end;
    ProcessDateStr := StringReplace(DateTimeToStr(Now), ':', '.', [rfReplaceAll, rfIgnoreCase]);
    DestPath := SortingCatalog+'\'+ProcessDateStr+'\';

    if FindFirst(IncludeTrailingBackslash(FolderPath) + '*.*', faAnyFile, SsearchRecord) = 0 then
    repeat
      if MatchStr(TPath.GetExtension(SsearchRecord.Name), ['.jpg', '.JPG', '.jpeg', '.JPEG']) then
//      try
        begin
          ProcessingProgressBar.Position := ProcessingProgressBar.Position+1;
          imageFullPath := IncludeTrailingBackslash(FolderPath)+SsearchRecord.Name;

          if DoNeuro.Checked then
          begin
            Python.PythonModule.SetVarFromVariant('folderPath', IncludeTrailingBackslash(FolderPath));
            Python.PythonModule.SetVarFromVariant('imageName', SsearchRecord.Name);
            Python.PythonModule.SetVarFromVariant('pred_thrsh', (StrToFloat(Settings.NeuralConfidence.Text)/100));
            Python.PythonEngine.ExecStrings(Python.Recognition.Lines);
          end;

          if SortToClassFolders.Checked then
          begin
            FirstAnimalClass := Functions.GetImageJsonFirstClass(imageFullPath);
            if CopyNonInformative.Checked or (FirstAnimalClass <> AnimalNotFound) then
            begin
              if not NonBinarySeparation.Checked then
              begin
                if CopyNonInformative.Checked and (FirstAnimalClass <> AnimalNotFound) then
                  FirstAnimalClass := 'Животное найдено'+'\'
                else if not CopyNonInformative.Checked then FirstAnimalClass := ''
                else FirstAnimalClass := FirstAnimalClass+'\';
              end
              else FirstAnimalClass := FirstAnimalClass+'\';

              if SortDates.Checked then
              begin
                ImageShotDate := Functions.GetImageJsonDate(imageFullPath);
                if ImageShotDate = MinDate then ImageShotDate := 'Дата не определена';
                ImageShotDate := ImageShotDate+'\';
                if FirstDates.Checked then
                  DestImagePath := DestPath+ImageShotDate+FirstAnimalClass;
                if FirstClasses.Checked then
                  DestImagePath := DestPath+FirstAnimalClass+ImageShotDate;
              end
              else DestImagePath := DestPath+FirstAnimalClass;

              ForceDirectories(DestImagePath);
              TFile.Copy(PWideChar(WideString(imageFullPath)), PWideChar(DestImagePath+SsearchRecord.Name), false);
            end;
          end;

          Stop := Now;
          Elapsed := SecondsBetween(Start, Stop);
          ProgressBarLabel.Caption := 'Обработано '+IntToStr(ProcessingProgressBar.Position)+'/'+TotalImagesLabel.Caption+
            ', осталось примерно '+FloatToStr(RoundTo(((Elapsed/ProcessingProgressBar.Position)*
            (StrToInt(TotalImagesLabel.Caption)-ProcessingProgressBar.Position))/60, -2))+' минут(ы)';
          Application.ProcessMessages; // Я знаю, что это плохо.
        end;
//      except
//        ProcessFailure := True;
//      end;
    until FindNext(SsearchRecord) <> 0;
  finally
    ImagePanel.Visible := True;
    Functions.CalculateFolderImagesStates(FolderPath);
    ProgressBarLabel.Free;
    FindClose(SsearchRecord);
    ImagesListBox.DblClick;
    ProcessingProgressBar.Visible := False;
    ProcessFolderButton.Visible := True;
    Main.Enabled := True;
    if not ProcessFailure then
    begin
      MessageBeep(MB_ICONASTERISK);
      Functions.MyMessageDlg('Все изображения успешно обработаны.',
        mtInformation, [mbYes], ['ОК'], 'Уведомление');
    end
    else
    begin
      MessageBeep(MB_ICONHAND);
      Functions.MyMessageDlg('Не все изображения были обработаны.',
        mtError, [mbYes], ['ОК'], 'Уведомление');
    end;
    Objects.FillObjectsGrid(Main, ActiveImagePath);
    ImagesListBox.Repaint;
    ShellExecute(Handle, 'open', PChar(DestPath), nil, nil, SW_SHOWNORMAL) ;
  end;
end;

procedure TMain.OpenFolderButtonClick(Sender: TObject);
var
  SR: TSearchRec;
  imagesStatesCounter: IntegerArray;
  ReadError: Boolean;
begin
with Main do
  with TFileOpenDialog.Create(nil) do
  begin
    ReadError := False;
    ImagePanel.Visible := False;
    LoadingLabel.Caption := 'ЗАГРУЗКА';
    Options := [fdoPickFolders, fdoPathMustExist, fdoForceFileSystem];
    if Execute then
    begin
      FolderPath := FileName;
      FolderPathEdit.Text := FileName;
      ImagesListBox.Items.Clear;

      if FindFirst(IncludeTrailingBackslash(FolderPath) + '*.*', faAnyFile, SR) = 0 then
      try
        repeat
            if MatchStr(TPath.GetExtension(SR.Name), ['.jpg', '.JPG', '.jpeg', '.JPEG']) then
            begin
              if not Functions.IsImageBroken(FolderPath+'\'+SR.Name) then
                ImagesListBox.Items.Add(SR.Name)
              else ReadError := True;
            end;
        until FindNext(SR) <> 0;
      finally
        FindClose(SR);
      end;
      ImagePanel.Visible := True;

      if (ImagesListBox.Count > 0) then
      begin
        IsFolderSelected := True;
        UpdateInterface;
        ImagesListBox.ItemIndex := 0;
        ImagesListBoxClick(Self);
        MainImage.Center := False;
        Functions.CalculateFolderImagesStates(FolderPath);
        ImagesListBoxDblClick(Self);
      end
      else
      begin
        Functions.MyMessageDlg('В этой папке изображений нет!', mtWarning, [mbOk], ['Ладно'], 'Предупреждение');
        IsFolderSelected := False;
        IsImageSelected := False;
        UpdateInterface;
        ActiveImagePath := '';
        MainImage.Picture := nil;
      end;

      if (Functions.GetFreeDriveSpace(SortingCatalog)-
        Functions.GetTotalImagesSize(FolderPath)) <= 0 then
        Functions.MyMessageDlg(
          'Размер файлов в выбранном каталоге превышает размер'+#13#10+
          'свободного пространства каталога сортированных снимков!'+#13#10+
          'Убадитесь, что на диске достаточно свободного пространства'+#13#10+
          'или измените каталог сортированных снимков в настройках.',
          mtWarning, [mbYes], ['ОК'], 'Предупреждение')
    end;
    if ReadError then
      Functions.MyMessageDlg(
        'Некоторые изображения не были обработаны'+#13#10+
        'по причине ошибки чтения файла изображения.',
        mtWarning, [mbYes], ['ОК'], 'Предупреждение');
    Free;
  end;
end;

procedure TMain.CheckProcVars;
begin
  if (DoNeuro.Checked or SortToClassFolders.Checked) and IsFolderSelected then
  begin
    ProcessFolderButton.Enabled := True;
    AutoProcMenuButton.Enabled := True;
  end
  else
  begin
    ProcessFolderButton.Enabled := False;
    AutoProcMenuButton.Enabled := False;
  end;
  SortDates.Enabled := SortToClassFolders.Checked;
  CopyNonInformative.Enabled := SortToClassFolders.Checked;
  FirstDates.Enabled := SortDates.Checked and SortToClassFolders.Checked;
  FirstClasses.Enabled := SortDates.Checked and SortToClassFolders.Checked;
  NonBinarySeparation.Enabled := SortToClassFolders.Checked;
end;

procedure TMain.DoNeuroClick(Sender: TObject);
begin
  CheckProcVars;
end;

procedure TMain.ChangeFolderButtonClick(Sender: TObject);
begin
  with TFileOpenDialog.Create(nil) do
  try
    Options := [fdoPickFolders, fdoPathMustExist, fdoForceFileSystem];
    if Execute then
    begin
      if FileName <> FolderPath then
//        MoveFolderEdit.Text := FileName
      else
      begin
//        MoveFolderEdit.Text := '';
        Functions.MyMessageDlg('Изображения уже находятся в этой папке!', mtWarning, [mbOk], ['Ладно'], 'Предупреждение');
      end;
    end;
  finally
    Free;
    CheckProcVars;
  end;
end;

// Список файлов ================================================================================

procedure TMain.ImagesListBoxClick(Sender: TObject);
var
  JPEGImg: TJPEGImage;
  ActiveImageName: String;
  ActivePreviewImagePath: String;
  ActiveImageDate: TDateTime;
begin
  try
    JPEGImg := TJpegImage.Create;
    ActivePreviewImagePath := IncludeTrailingBackslash(FolderPath)+ImagesListBox.Items[ImagesListBox.ItemIndex];
    JPEGImg.LoadFromFile(ActivePreviewImagePath);
    JPEGImg.Scale := jsEighth;
    ImagePreview.Picture.Assign(JPEGImg);
  finally
    JPEGImg.Free;
  end;
  // Наименование
  ActiveImageName := ImagesListBox.Items[ImagesListBox.ItemIndex];
  ImagePreviewNameLabel.Caption := Functions.StrMaxLen(ActiveImageName, 30);
  // Дата
  ActiveImageDate := FileDateToDateTime(FileAge(ActivePreviewImagePath));
  ImagePreviewDateLabel.Caption := DateToStr(ActiveImageDate);
  //
  ImagePreviewObjectsList.Clear;
  ImagePreviewObjectsList.Items.Add(Python.GetJsonExif(ActivePreviewImagePath));
end;

procedure TMain.ImagesListBoxDblClick(Sender: TObject);
var
  ActiveImageName: String;
  ActiveImageDate: TDateTime;
begin
  try
    IsImageSelected := True;
    IsObjectsExists := False;
    ResetEditingUI;
    ActiveImagePath := IncludeTrailingBackslash(FolderPath)+ImagesListBox.Items[ImagesListBox.ItemIndex];
    // Наименование
    ActiveImageName := ImagesListBox.Items[ImagesListBox.ItemIndex];
    ImageNameLabel.Caption := Functions.StrMaxLen(ActiveImageName, 50);
    // Дата
    ActiveImageDate := FileDateToDateTime(FileAge(ActiveImagePath));
    ImageDateLabel.Caption := DateToStr(ActiveImageDate);
    PhotoDateLabel.Caption := 'Изображение не обработано';
    //
    Objects.FillObjectsGrid(Main, ActiveImagePath);
    if ObjectsGrid.RowCount <> 0 then
      IsObjectsExists := True;
    UpdateInterface;
    Functions.AssignImageAndDrawBoxes(Main, ActiveImagePath);
  except
    Objects.ResetObjectsGrid(Main);
    UpdateInterface;
  end;
end;

procedure TMain.ImagesListBoxDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  LBox: TListBox;
  R: TRect;
  Item: string;
  TextTopPos, TextLeftPos, TextHeight: Integer;
  ActiveImageState: string;
const
  IMAGE_TEXT_SPACE = 5;
begin
// ⚪⚫✕
  LBox := Control as TListBox;
  R := Rect;
  LBox.Canvas.FillRect(R);
  Item := LBox.Items[Index];
  TextHeight := LBox.Canvas.TextHeight(Item);
  TextLeftPos := R.Left + 20 + IMAGE_TEXT_SPACE;
  TextTopPos := R.Top + R.Height div 2 - TextHeight div 2;
  LBox.Canvas.TextOut(TextLeftPos, TextTopPos, Item);
  try
  ActiveImageState := Functions.GetImageJsonState(FolderPath+'/'+Item);
  if ActiveImageState = 'Raw' then
    LBox.Canvas.TextOut(0, TextTopPos, '✕')
  else if ActiveImageState = 'Informative' then
    LBox.Canvas.TextOut(0, TextTopPos, '⚫')
  else if ActiveImageState = 'NonInformative' then
    LBox.Canvas.TextOut(0, TextTopPos, '⚪');
  except
//    Objects.ResetObjectsGrid(Processor);
  end;
end;

procedure TMain.ImagesListBoxMouseEnter(Sender: TObject);
begin
  ImagesListBox.SetFocus();
end;

// Изображение ================================================================================

procedure TMain.AllowImageResizeClick(Sender: TObject);
begin
  ImageScaleTrackBar.Enabled := AllowImageResize.Checked;
  mainImageResize;
end;
procedure TMain.ImageScaleTrackBarChange(Sender: TObject);
begin
  mainImageResize;
end;

procedure TMain.PrevImageButtonClick(Sender: TObject);
begin
  if ImagesListBox.ItemIndex <> 0 then
    ImagesListBox.ItemIndex := ImagesListBox.ItemIndex-1
  else
    ImagesListBox.ItemIndex := ImagesListBox.Count-1;
  ImagesListBoxClick(Self);
  ImagesListBoxDblClick(Self);
end;

procedure TMain.NextImageButtonClick(Sender: TObject);
begin
  if ImagesListBox.ItemIndex+1 < ImagesListBox.Count then
    ImagesListBox.ItemIndex := ImagesListBox.ItemIndex+1
  else
    ImagesListBox.ItemIndex := 0;
  ImagesListBoxClick(Self);
  ImagesListBoxDblClick(Self);
end;

procedure TMain.AutoFindButtonClick(Sender: TObject);
begin
  Python.PythonModule.SetVarFromVariant('imagePath', ActiveImagePath);
  Python.PythonEngine.ExecStrings(Python.Recognition.Lines);
  ImagesListBox.DblClick;
end;

procedure TMain.MainImageMouseEnter(Sender: TObject);
begin
  if MarkingNewObj then
    Screen.Cursor := crCross;
  if Settings.HideBoxesOnMouseEnter.Checked then
    Functions.AssignImageAndDrawBoxes(Main, ActiveImagePath, False);
end;

procedure TMain.MainImageMouseLeave(Sender: TObject);
begin
  Screen.Cursor := crDefault;
  if Settings.HideBoxesOnMouseEnter.Checked then
    Functions.AssignImageAndDrawBoxes(Main, ActiveImagePath);
end;

// Объект ================================================================================

procedure TMain.ChangePhotoDateClick(Sender: TObject);
var
  date: string;
begin
  date := Functions.InputDate('Изменение даты');
  if date <> '' then
  begin
    ImageShotDate := date;
    PhotoDateLabel.Caption := ImageShotDate;
    Python.SetJsonExif(ActiveImagePath, Objects.GridObjectsToJsonString(Main));
  end;
end;

procedure TMain.MarkObjectButtonClick(Sender: TObject);
begin
  if Settings.HideBoxesOnMouseEnter.Checked then
    Functions.AssignImageAndDrawBoxes(Main, ActiveImagePath, False);
  Objects.MarkObject(Main);
end;

procedure TMain.MainImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Objects.SetFirstPoint(Main, Button, X, Y);
end;

procedure TMain.MainImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Objects.SetSecondPointAndDraw(Main, X, Y)
end;

procedure TMain.MainImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Objects.DoMarkingNewObject(Main, ActiveImagePath, FolderPath, Button, X, Y);
  Objects.EndMarkingNewObject(Main);
end;

procedure TMain.ChangeClassButtonClick(Sender: TObject);
begin
  Objects.ChangeObjClass(Main);
end;

procedure TMain.DeleteObjButtonClick(Sender: TObject);
begin
  Objects.DeleteObj(Main, ActiveImagePath, FolderPath);
end;

procedure TMain.ApplyChangingButtonClick(Sender: TObject);
begin
  Objects.ApplyChangingObjClass(Main, ActiveImagePath);
end;

procedure TMain.CancelChangingButtonClick(Sender: TObject);
begin
  ObjectGroup.Visible := True;
  ObjectsGrid.Enabled := True;
  ObjectClassGroup.Visible := False;
end;

procedure TMain.ObjectsGridClick(Sender: TObject);
begin
  Functions.AssignImageAndDrawBoxes(Main, ActiveImagePath);
end;

procedure TMain.ObjectsGridMouseEnter(Sender: TObject);
begin
  ObjectsGrid.SetFocus();
end;


end.

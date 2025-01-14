unit FunctionsUnit;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Dialogs, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls,
  System.IOUtils, System.StrUtils, Vcl.FileCtrl, System.Win.ComObj, System.JSON, Vcl.Graphics,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.Grids, System.Types, System.Math, Vcl.Comctrls;

type
  StringArray = array of string;
  IntegerArray = array of integer;
  TCharSet = set of char;
  TStringArray = array of string;
  TFunctionsModule = class(TObject)
    function MyStrToFloat(const S: string): Double;
    function SplitString(const str: string; const delims: TCharSet): StringArray;
    function StrMaxLen(const S: string; MaxLen: integer): string;
    function MyMessageDlg(CONST Msg: string; DlgTypt: TmsgDlgType; button: TMsgDlgButtons;
      Caption: ARRAY OF string; dlgcaption: string): Integer;
    function InputDate(const ACaption: string): string;
    function GetImageJsonState(ImagePath: String): String;
    function GetImageJsonFirstClass(ImagePath: String): String;
    function GetImageJsonDate(ImagePath: String): String;
    procedure CalculateFolderImagesStates(folderPath: string);
    function IsImageBroken(ImagePath: String): Boolean;
    procedure AssignImageAndDrawBoxes(Form: TForm; ImagePath: String; Draw: boolean = True);
    function getAnimalDictValue(key: string): string;
    function getAnimalDictKey(value: string): string;
    function GetTotalImagesSize(FolderPath: string): Integer;
    function GetFreeDriveSpace(FolderPath: string): int64;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Functions: TFunctionsModule;

implementation

uses
  Generics.Collections, MainUnit, PythonUnit, SettingsUnit, AnimalsObjectsUnit;

{%CLASSGROUP 'Vcl.Controls.TControl'}

function TFunctionsModule.MyStrToFloat(const S: string): Double;
const
  Komma: TFormatSettings = (DecimalSeparator: ',');
  Dot: TFormatSettings = (DecimalSeparator: '.');
begin
  if not TryStrToFloat(S, Result, Komma) then
    Result := StrToFloat(S, Dot);
end;

function TFunctionsModule.SplitString(const str: string; const delims: TCharSet): StringArray;
var
  SepPos: IntegerArray;
  i: Integer;
begin
  SetLength(SepPos, 1);
  SepPos[0] := 0;
  for i := 1 to length(str) do
    if str[i] in delims then
    begin
      SetLength(SepPos, length(SepPos) + 1);
      SepPos[high(SepPos)] := i;
    end;
  SetLength(SepPos, length(SepPos) + 1);
  SepPos[high(SepPos)] := length(str) + 1;
  SetLength(result, high(SepPos));
  for i := 0 to high(SepPos) -  1 do
    result[i] := Trim(Copy(str, SepPos[i] + 1, SepPos[i+1] - SepPos[i] - 1));
end;

function TFunctionsModule.StrMaxLen(const S: string; MaxLen: integer): string;
var
  i: Integer;
begin
  result := S;
  if Length(result) <= MaxLen then Exit;
  SetLength(result, MaxLen);
  for i := MaxLen downto MaxLen - 2 do
    result[i] := '.';
end;

// if MyMessageDlg('Текст' + #13#10 + 'Текст', mtInformation, [mbYes, mbNo], ['Да','Нет'], 'Заголовок') = mrYes;
function TFunctionsModule.MyMessageDlg(CONST Msg: string; DlgTypt: TmsgDlgType; button: TMsgDlgButtons;
  Caption: ARRAY OF string; dlgcaption: string): Integer;
var
  aMsgdlg: TForm;
  i: Integer;
  Dlgbutton: Tbutton;
  Captionindex: Integer;
begin
  aMsgdlg := createMessageDialog(Msg, DlgTypt, button);
  aMsgdlg.Caption := dlgcaption;
  aMsgdlg.BiDiMode := bdLeftToRight;
  Captionindex := 0;
  for i := 0 to aMsgdlg.componentcount - 1 Do
  begin
    if (aMsgdlg.components[i] is Tbutton) then
    Begin
      Dlgbutton := Tbutton(aMsgdlg.components[i]);
      if Captionindex <= High(Caption) then
        Dlgbutton.Caption := Caption[Captionindex];
      inc(Captionindex);
    end;
  end;
  Result := aMsgdlg.Showmodal;
end;

function TFunctionsModule.InputDate(const ACaption: string): string;
  function GetCharSize(Canvas: TCanvas): TPoint;
  var
    I: Integer;
    Buffer: array[0..51] of Char;
  begin
    for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
    for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
    GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
    Result.X := Result.X div 52;
  end;
var
  Form: TForm;
  DateTimePicker: TDateTimePicker;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
begin
  Result := '';
  Form   := TForm.Create(Application);
  with Form do
    try
      Canvas.Font := Font;
      DialogUnits := GetCharSize(Canvas);
      BorderStyle := bsDialog;
      Caption     := ACaption;
      ClientWidth := MulDiv(140, DialogUnits.X, 4);
      Position    := poScreenCenter;
      DateTimePicker := TDateTimePicker.Create(Form);
      with DateTimePicker do
      begin
        Parent := Form;
        Left     := MulDiv(8, DialogUnits.X, 4);
        Top      := MulDiv(8, DialogUnits.Y, 8);
      end;
      ButtonTop    := DateTimePicker.Top + DateTimePicker.Height + 15;
      ButtonWidth  := MulDiv(50, DialogUnits.X, 4);
      ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
      with TButton.Create(Form) do
      begin
        Parent      := Form;
        Caption     := 'Запомнить';
        ModalResult := mrOk;
        default     := True;
        SetBounds(MulDiv(18, DialogUnits.X, 4), ButtonTop, ButtonWidth,
          ButtonHeight);
      end;
      with TButton.Create(Form) do
      begin
        Parent      := Form;
        Caption     := 'Отмена';
        ModalResult := mrCancel;
        Cancel      := True;
        SetBounds(MulDiv(72, DialogUnits.X, 4), DateTimePicker.Top + DateTimePicker.Height + 15,
          ButtonWidth, ButtonHeight);
        Form.ClientHeight := Top + Height + 13;
      end;
      if ShowModal = mrOk then
      begin
        Result := DateToStr(DateTimePicker.Date);
      end;
    finally
      Form.Free;
    end;
end;

function TFunctionsModule.getAnimalDictValue(key: string): string;
var
  i: integer;
begin
  Result := 'None';
  for i := 0 to Length(AnimalClasses) do
    if AnimalDict[i][0] = key then
    begin
      Result := AnimalDict[i][1];
      break;
    end;
end;
function TFunctionsModule.getAnimalDictKey(value: string): string;
var
  i: integer;
begin
  Result := 'None';
  for i := 0 to Length(AnimalClasses) do
    if AnimalDict[i][1] = value then
    begin
      Result := AnimalDict[i][0];
      break;
    end;
end;

function TFunctionsModule.IsImageBroken(ImagePath: String): Boolean;
var
  JPEGImg: TJPEGImage;
begin
  Result := False;
  JPEGImg := TJpegImage.Create;
  try
    JPEGImg.LoadFromFile(ImagePath);
  except
//  On InvalidImageDataError do
    Result := True;
  end;
  JPEGImg.Free;
end;

procedure TFunctionsModule.AssignImageAndDrawBoxes(Form: TForm; ImagePath: String; Draw: boolean = True);
var
  JPEGImg: TJPEGImage;
  Bitmap: TBitmap;
  i: integer;
  frameColour: integer;
  textColour: integer;
  procedure drawBoxes(i: Integer; FontColor, BoxColor: Integer);
  var
    box: TList<double>;
    str: string;
  begin
    with TStringGrid(Form.FindComponent('ObjectsGrid')) do
    begin
      box := TList<double>.Create;
      for str in SplitString(Cells[3, i], [',', '[', ']', ' ', '"']) do
        if str <> '' then
          box.Add(MyStrToFloat(str));
      with Bitmap do
      begin
        Canvas.Font.Color := FontColor;
        Canvas.Pen.Color := BoxColor;
        Canvas.Brush.Style := bsClear;
        Canvas.Rectangle(Rect(
          round(Width*box[0]),
          round(Height*box[1]),
          round(Width*box[2]),
          round(Height*box[3])));
        Canvas.Brush.Style := bsSolid;
        Canvas.Brush.Color := BoxColor;
        Canvas.TextOut(round(Width*box[0]), round(Height*box[1]),
          '#'+Cells[0, i]+' '+Cells[1, i]+' ('+Cells[2, i]+'%)');
      end;
      box.Free;
    end;
  end;
begin
  if ImagePath <> '' then
  with Form do
  begin
    JPEGImg := TJpegImage.Create;
    JPEGImg.LoadFromFile(ImagePath);
    if Settings.Compression.ItemIndex = 1 then
      JPEGImg.Scale := jsHalf
    else if Settings.Compression.ItemIndex = 2 then
      JPEGImg.Scale := jsQuarter;
    Bitmap := TBitmap.create;
    Bitmap.Assign(JPEGImg);
//    Bitmap.SetSize(1920,1080);
//    Bitmap.Canvas.StretchDraw(Rect(0,0,1920,1080), JPEGImg);
    if Draw = True then
    begin
      Bitmap.Canvas.Pen.Width := Round(Bitmap.Width*0.003);
      Bitmap.Canvas.Font.Name := 'Segoe UI';
      Bitmap.Canvas.Font.Size := 1;
      while Bitmap.Canvas.Font.Size < Bitmap.Width*0.017 do
      begin
        Bitmap.Canvas.Font.Size := Bitmap.Canvas.Font.Size + 1;
      end;
      with TStringGrid(FindComponent('ObjectsGrid')) do
      if GetImageJsonState(ImagePath) = 'Informative' then
      begin
        for i := 1 to RowCount-1 do
        if i <> Row then
        begin
          drawBoxes(i, clBlack, clSilver);
        end;
        drawBoxes(Row, clWhite, clHighlight);
      end;
    end;
    TImage(FindComponent('MainImage')).Picture.Bitmap.assign(Bitmap);
    JPEGImg.Free;
    Bitmap.Free;
  end;
end;

function TFunctionsModule.GetImageJsonState(ImagePath: String): String;
var
  JSONData: string;
  JSonObject: TJSonObject;
  ImageJson: TJSonValue;
  Animals: TJSONArray;
begin
  JSONData := Python.GetJsonExif(ImagePath);
  JSonObject := TJSonObject.Create;
  ImageJson := JSonObject.ParseJSONValue(JSONData) as TJSONObject;
  if ImageJson.FindValue('animals') <> nil then
  begin
    Animals := ImageJson.GetValue<TJSONArray>('animals');
    if Animals.Items[0].Value <> 'None' then Result := 'Informative'
    else Result := 'NonInformative';
  end
  else Result := 'Raw';
  JSonObject.Free;
end;

function TFunctionsModule.GetImageJsonFirstClass(ImagePath: String): String;
var
  JSONData: string;
  JSonObject: TJSonObject;
  ImageJson: TJSonValue;
  Animals: TJSONArray;
  Animal: TJSonValue;
  ObjClass: string;
begin
  JSONData := Python.GetJsonExif(ImagePath);
  JSonObject := TJSonObject.Create;
  ImageJson := JSonObject.ParseJSONValue(JSONData) as TJSONObject;
  if ImageJson.FindValue('animals') <> nil then
  begin
    Animals := ImageJson.GetValue<TJSONArray>('animals');
    Animal := Animals.Items[0];
    if Animal.Value <> 'None' then
    begin
      ObjClass := Animal.GetValue<string>('class');
      Result := getAnimalDictValue(ObjClass);
    end
    else Result := AnimalNotFound;
  end
  else Result := AnimalNotFound;
  JSonObject.Free;
end;

function TFunctionsModule.GetImageJsonDate(ImagePath: String): String;
var
  JSONData: string;
  JSonObject: TJSonObject;
  ImageJson: TJSonValue;
begin
  JSONData := Python.GetJsonExif(ImagePath);
  JSonObject := TJSonObject.Create;
  ImageJson := JSonObject.ParseJSONValue(JSONData) as TJSONObject;
  if ImageJson.FindValue('date') <> nil then
  begin
    Result := ImageJson.GetValue<string>('date');
  end
  else Result := MinDate;
  JSonObject.Free;
end;

procedure TFunctionsModule.CalculateFolderImagesStates(folderPath: string);
var
  SR: TSearchRec;
  imagePath: string;
  JSONData: string;
  JSonObject: TJSonObject;
  ImageJson: TJSonValue;
  Animals: TJSONArray;
  inform, noninform, proc, nonproc: integer;
  ImageBroken: Boolean;
begin
  inform := 0;
  noninform := 0;
  proc := 0;
  nonproc := 0;
  if FindFirst(IncludeTrailingBackslash(folderPath) + '*.*', faAnyFile, SR) = 0 then
  try
    repeat
      if MatchStr(TPath.GetExtension(SR.Name), ['.jpg', '.JPG', '.jpeg', '.JPEG']) then
      begin
        imagePath := IncludeTrailingBackslash(folderPath)+SR.Name;
        ImageBroken := False;;
        try
          JSONData := Python.GetJsonExif(ImagePath);
        except
          nonproc := nonproc+1;
          ImageBroken := True;
        end;
        if not ImageBroken then
        begin
          JSonObject := TJSonObject.Create;
          ImageJson := JSonObject.ParseJSONValue(JSONData) as TJSONObject;
          if ImageJson.FindValue('animals') <> nil then
          begin
            Animals := ImageJson.GetValue<TJSONArray>('animals');
            if Animals.Items[0].Value <> 'None' then inform := inform+1 // Информативные
            else noninform := noninform+1; // Не информативные
            proc := proc+1; // Обработано
          end
          else nonproc := nonproc+1; // Не обработано
          JSonObject.Free;
        end;
      end;
    until FindNext(SR) <> 0;
  finally
    FindClose(SR);
    with Main do
    begin
      TotalImagesLabel.Caption := ImagesListBox.Count.ToString;
      InfoImagesLabel.Caption := inform.ToString;
      ProcImagesLabel.Caption := proc.ToString;
      NProcImagesLabel.Caption := nonproc.ToString;
    end;
  end;
end;

function TFunctionsModule.GetTotalImagesSize(FolderPath: string): Integer;
var
  SsearchRecord: TSearchRec;
  TotalSize: Integer;
begin
  if FindFirst(IncludeTrailingBackslash(FolderPath) + '*.*', faAnyFile, SsearchRecord) = 0 then
    repeat
      if MatchStr(TPath.GetExtension(SsearchRecord.Name), ['.jpg', '.JPG', '.jpeg', '.JPEG']) then
      begin
        TotalSize := TotalSize+SsearchRecord.Size;
      end;
    until FindNext(SsearchRecord) <> 0;
  Result := TotalSize;
end;

function TFunctionsModule.GetFreeDriveSpace(FolderPath: string): int64;
var
  DriveLetter : char;
  DriveNumber : byte;
  FreeBytes : int64;
begin
  DriveLetter := UpperCase(ExtractFileDrive(FolderPath))[1];
  DriveNumber := 1+Ord(DriveLetter)-Ord('A');
  FreeBytes := DiskFree(DriveNumber);
  Result := FreeBytes;
end;

end.


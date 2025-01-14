unit AnimalsObjectsUnit;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Dialogs, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls,
  System.IOUtils, System.StrUtils, Vcl.FileCtrl, System.Win.ComObj, System.JSON, Vcl.Graphics,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.Grids, System.Types, System.Math;

type
  TAnimalDictConst = array[0..18, 0..1] of String;
  TObjectsModule = class(TObject)
    function getAnimalDictValue(key: string): string;
    function getAnimalDictKey(value: string): string;
    function GridObjectsToJsonString(Form: TForm): string;
    procedure FillObjectsGrid(Form: TForm; ImagePath: String);
    procedure MarkObject(Form: TForm);
    procedure StartMarkingNewObject(Form: TForm);
    procedure DoMarkingNewObject(Form: TForm; ImagePath, FolderPath: string; Button: TMouseButton; X, Y: Integer);
    procedure EndMarkingNewObject(Form: TForm);
    procedure SetFirstPoint(Form: TForm; Button: TMouseButton; X, Y: Integer);
    procedure SetSecondPointAndDraw(Form: TForm; X, Y: Integer);
    procedure NormAndSetSelRect(Form: TForm; p1, p2: TPoint);
    procedure DrawRect(Form: TForm);
    procedure ResetObjectsGrid(Form: TForm);
    procedure ChangeObjClass(Form: TForm);
    procedure ApplyChangingObjClass(Form: TForm; ImagePath: string);
    procedure DeleteObj(Form: TForm; ImagePath, FolderPath: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  MinDate: string = '10.01.2001';
  AnimalClasses: array[0..18] of string =
  ('Badger',
  'Wolf',
  'Capercaillie',
  'Rabbit',
  'Boar',
  'Musk deer',
  'Deer',
  'Fox',
  'Moose',
  'Siberian stag',
  'Brown bear',
  'Birds',
  'Wolverine',
  'Lynx',
  'Reindeer',
  'Dog',
  'Human',
  'Indefined',
  'Absent');
  AnimalNotFound: string = 'Животное не найдено';

var
  AnimalDict: TAnimalDictConst =
  (('Badger', 'Барсук'),
  ('Wolf', 'Волк'),
  ('Capercaillie', 'Глухарь'),
  ('Rabbit', 'Заяц'),
  ('Boar', 'Кабан'),
  ('Musk deer', 'Кабарга'),
  ('Deer', 'Косуля'),
  ('Fox', 'Лисица'),
  ('Moose', 'Лось'),
  ('Siberian stag', 'Марал'),
  ('Brown bear', 'Медведь'),
  ('Birds', 'Птица'),
  ('Wolverine', 'Росомаха'),
  ('Lynx', 'Рысь'),
  ('Reindeer', 'Северный олень'),
  ('Dog', 'Собака'),
  ('Human', 'Человек'),
  ('Indefined', 'Не определен'),
  ('Absent', 'Отсутствует'));
  Objects: TObjectsModule;
  TempOriginalBitmap: TBitmap;
  // Объекты
  MarkingNewObj: boolean = false;
  ImageShotDate: string;
  // Выделение нового
  Selecting: boolean = false;
  FirstPoint: TPoint;
  sel: TRect;

implementation

uses
  Generics.Collections, MainUnit, PythonUnit, SettingsUnit, FunctionsUnit;

function TObjectsModule.getAnimalDictValue(key: string): string;
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
function TObjectsModule.getAnimalDictKey(value: string): string;
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

function TObjectsModule.GridObjectsToJsonString(Form: TForm): string;
var
   Animal: TJSonObject;
   AnimalsArray: TJSONArray;
   Box: TJSONArray;
   JsonData: TJSONObject;
   i: integer;
   ints: IntegerArray;
   str: string;
begin
  with TStringGrid(Form.FindComponent('ObjectsGrid')) do
  begin
    AnimalsArray := TJSONArray.Create;
    JsonData := TJSONObject.Create;
    for i := 1 to RowCount-1 do
    begin
      Animal := TJSONObject.Create;
      Animal.AddPair('class', getAnimalDictKey(Cells[1, i]));
      Animal.AddPair('prob', Cells[2, i]);
      Box := TJSONArray.Create;
      for str in Functions.SplitString(Cells[3, i], [',', '[', ']', ' ', '"']) do
        if str <> '' then
          Box.Add(Functions.MyStrToFloat(str));
      Animal.AddPair('box', Box);
      AnimalsArray.Add(Animal);
    end;
    JsonData.AddPair('animals', AnimalsArray);
    JsonData.AddPair('date', ImageShotDate);
    Result := JsonData.ToString;
  end;
  JsonData.Free;
end;

procedure TObjectsModule.FillObjectsGrid(Form: TForm; ImagePath: String);
var
  JSONData: string;
  JSonObject: TJSonObject;
  ImageJson: TJSonValue;
  v: string;
  Animals: TJSONArray;
  Animal: TJSonValue;
  ObjClass: string;
  ObjProb: string;
  PhotoDate: string;
  ObjBox: TJSONArray;
  i: integer;
begin
  TPanel(Form.FindComponent('ProcessBottomPanel')).Visible := False;
  TButton(Form.FindComponent('MarkNewFirstObjectButton')).Visible := False;
  TLabel(Form.FindComponent('ImageObjectsLabel')).Caption := 'Изображение не обработано.';
  JSONData := Python.GetJsonExif(ImagePath);
  JSonObject := TJSonObject.Create;
  ImageJson := JSonObject.ParseJSONValue(JSONData) as TJSONObject;
  if ImageJson.FindValue('animals') <> nil then // Обработанное
  begin
    Animals := ImageJson.GetValue<TJSONArray>('animals');
    TStringGrid(Form.FindComponent('ObjectsGrid')).RowCount := Animals.Count+1;
    if Animals.Items[0].Value <> 'None' then // Информативное
    begin
      for Animal in Animals do
      begin
        i := i+1;
        try
          ObjClass := Animal.GetValue<string>('class');
          ObjProb := Animal.GetValue<string>('prob');
          ObjBox := Animal.GetValue<TJSONArray>('box');
          with Form.FindComponent('ObjectsGrid') as TStringGrid do
          begin
            Cells[0, i] := i.ToString;
            Cells[1, i] := getAnimalDictValue(ObjClass);
            Cells[2, i] := ObjProb;
            Cells[3, i] := ObjBox.ToString;
          end;
        except
          Python.SetJsonExif(ImagePath, '{"animals": ["None"]}');
        end;

        TLabel(Form.FindComponent('ImageObjectsLabel')).Caption :=
          'Объекты на изображении ('+IntToStr(Animals.Count)+'):';
        TPanel(Form.FindComponent('ProcessBottomPanel')).Visible := True;
      end;
    end
    else
    begin
      TLabel(Form.FindComponent('ImageObjectsLabel')).Caption := 'Объекты на изображении не найдены.';
      TButton(Form.FindComponent('MarkNewFirstObjectButton')).Visible := True;
    end;
    if ImageJson.FindValue('date') <> nil then // Есть дата
    begin
      PhotoDate := ImageJson.GetValue<string>('date');
      if PhotoDate = MinDate then PhotoDate := 'Дата не определена';
      TLabel(Form.FindComponent('PhotoDateLabel')).Caption := PhotoDate;
    end;
  end
  else
    TButton(Form.FindComponent('MarkNewFirstObjectButton')).Visible := True;
  if ImageJson.FindValue('date') <> nil then // Содержит дату
    ImageShotDate := ImageJson.GetValue<string>('date')
  else ImageShotDate := MinDate;
  JSonObject.Free;
end;


procedure TObjectsModule.MarkObject(Form: TForm);
begin
  if not MarkingNewObj then
    StartMarkingNewObject(Form)
  else
    EndMarkingNewObject(Form);
end;

procedure TObjectsModule.StartMarkingNewObject(Form: TForm);
begin
  MarkingNewObj := True;
  TPanel(Form.FindComponent('ImagePanel')).Color := clYellow;
  TButton(Form.FindComponent('MarkObjectButton')).Caption := '✖';
  TButton(Form.FindComponent('MarkNewFirstObjectButton')).Caption := 'Отменить выделение нового объекта';
  TempOriginalBitmap := TBitmap.create;
  TempOriginalBitmap.Height := TImage(Form.FindComponent('MainImage')).Picture.Bitmap.Height;
  TempOriginalBitmap.Width := TImage(Form.FindComponent('MainImage')).Picture.Bitmap.Width;
  TempOriginalBitmap.Canvas.Draw(0, 0, TImage(Form.FindComponent('MainImage')).Picture.Bitmap);
end;

procedure TObjectsModule.DoMarkingNewObject(Form: TForm; ImagePath, FolderPath: string; Button: TMouseButton; X, Y: Integer);
const
  Dot: TFormatSettings = (DecimalSeparator: '.');
var
  rowNum: Integer;
  function normX(Form: TForm; x: Integer): double;
  begin
      result := RoundTo((x/TImage(Form.FindComponent('MainImage')).Picture.Width), -4);
  end;
  function normY(Form: TForm; x: Integer): double;
  begin
      result := RoundTo((x/TImage(Form.FindComponent('MainImage')).Picture.Height), -4);
  end;
begin
  if (not Selecting) then Exit;
  NormAndSetSelRect(Form, FirstPoint, Point(X,Y));
  DrawRect(Form);
  Selecting := false;

  if not (Functions.GetImageJsonState(ImagePath) = 'Informative') then
  begin
    ResetObjectsGrid(Form);
    TPanel(Form.FindComponent('ProcessBottomPanel')).Visible := True;
    rowNum := 1;
    TLabel(Form.FindComponent('ImageObjectsLabel')).Caption := 'Объекты на изображении:';
  end
  else
  begin
    with TStringGrid(Form.FindComponent('ObjectsGrid')) do
    begin
      rowNum := RowCount;
      RowCount := RowCount + 1;
    end;
  end;
  with TStringGrid(Form.FindComponent('ObjectsGrid')) do
  begin
    Cells[0, rowNum] := IntToStr(RowCount-1);
    Cells[1, rowNum] := 'Не определен';
    Cells[2, rowNum] := '100';
    Cells[3, rowNum] :=
      '['+FloatToStr(normX(Form, sel.Left), Dot)+
      ','+FloatToStr(normY(Form, sel.Top), Dot)+
      ','+FloatToStr(normX(Form, sel.Right), Dot)+
      ','+FloatToStr(normY(Form, sel.Bottom), Dot)+']';
    Row := RowCount-1;
  end;
  Python.SetJsonExif(ImagePath, GridObjectsToJsonString(Form));
  Functions.CalculateFolderImagesStates(FolderPath);
  FillObjectsGrid(Form, ImagePath);
  Functions.AssignImageAndDrawBoxes(Form, ImagePath);
  TempOriginalBitmap.Free;
end;

procedure TObjectsModule.EndMarkingNewObject(Form: TForm);
begin
  if MarkingNewObj then
  begin
    MarkingNewObj := False;
    TPanel(Form.FindComponent('ImagePanel')).Color := clBtnFace;
    TButton(Form.FindComponent('MarkObjectButton')).Caption := '➕';
    TButton(Form.FindComponent('MarkNewFirstObjectButton')).Caption := 'Выделить новый объект';
    Screen.Cursor := crDefault;
  end;
end;

procedure TObjectsModule.SetFirstPoint(Form: TForm; Button: TMouseButton; X, Y: Integer);
begin
  if Selecting or not MarkingNewObj then Exit;
  Selecting := true;
  FirstPoint := (Point(X,Y));
  sel := Bounds(FirstPoint.X, FirstPoint.Y, 0, 0);
end;

procedure TObjectsModule.SetSecondPointAndDraw(Form: TForm; X, Y: Integer);
begin
  if not Selecting then Exit;
  NormAndSetSelRect(Form, FirstPoint, Point(X,Y));
  DrawRect(Form);
end;

procedure TObjectsModule.DrawRect(Form: TForm);
begin
  TImage(Form.FindComponent('MainImage')).Picture.Bitmap.Canvas.Draw(0, 0, TempOriginalBitmap);
  with TImage(Form.FindComponent('MainImage')).Picture.Bitmap do
  begin
    Canvas.Pen.Width := Round(Width*0.003);
    Canvas.Pen.Color := clYellow;
    Canvas.Brush.Style := bsClear;
    Canvas.Rectangle(sel.Left, sel.Top, sel.Right, sel.Bottom);
  end;
end;

procedure TObjectsModule.NormAndSetSelRect(Form: TForm; p1, p2: TPoint);
var
  a, b: real;
begin
  // Правка координат к разрешению изображения
  with TImage(Form.FindComponent('MainImage')) do
  begin
    a := ((Picture.Width)/Width);
    b := ((Picture.Height)/Height);
  end;
  if a <= b then
  begin
    p1.X := Trunc(p1.X*b);
    p1.Y := Trunc(p1.Y*b);
    p2.X := Trunc(p2.X*b);
    p2.Y := Trunc(p2.Y*b);
  end else
  begin
    p1.X := Trunc(p1.X*a);
    p1.Y := Trunc(p1.Y*a);
    p2.X := Trunc(p2.X*a);
    p2.Y := Trunc(p2.Y*a);
  end;
  // Нормализация второй точки
  if p1.x < p2.x then begin
    sel.Left := p1.x;
    sel.Right := p2.x;
  end else begin
    sel.Left := p2.x;
    sel.Right := p1.x;
  end;
  if p1.y < p2.y then begin
    sel.Top := p1.y;
    sel.Bottom := p2.y;
  end else begin
    sel.Top := p2.y;
    sel.Bottom := p1.y;
  end;
end;

procedure TObjectsModule.ResetObjectsGrid(Form: TForm);
begin
  with TStringGrid(Form.FindComponent('ObjectsGrid')) do
  begin
    RowCount := 0;
    RowCount := 2;
    Rows[1].Clear;
    FixedRows := 1;
    Cells[0, 0] := '№';
    ColWidths[0] := 25;
    Cells[1, 0] := 'Объект';
    ColWidths[1] := 150;
    Cells[2, 0] := 'Уверенность';
    ColWidths[2] := 90;
    Cells[3, 0] := 'Координаты';
    ColWidths[3] := 230;
  end;
end;

procedure TObjectsModule.ChangeObjClass(Form: TForm);
var
  animalClass: string;
  gridCaption: string;
begin
  TPanel(Form.FindComponent('ObjectGroup')).Visible := False;
  TGroupBox(Form.FindComponent('ObjectClassGroup')).Visible := True;
  with TStringGrid(Form.FindComponent('ObjectsGrid')) do
  begin
    Enabled := False;
    gridCaption := Cells[1, Row];
  end;
  with TComboBox(Form.FindComponent('AnimalClassesCB')) do
  begin
    Items.Clear;
    for animalClass in AnimalClasses do
      Items.Add(getAnimalDictValue(animalClass));
    ItemIndex := 0;
  end;
  TLabel(Form.FindComponent('CurrentObjClassLabel')).Caption := gridCaption;
end;

procedure TObjectsModule.ApplyChangingObjClass(Form: TForm; ImagePath: string);
var
  newClassName: string;
begin
  newClassName := TComboBox(Form.FindComponent('AnimalClassesCB')).Text;
  TPanel(Form.FindComponent('ObjectGroup')).Visible := True;
  TGroupBox(Form.FindComponent('ObjectClassGroup')).Visible := False;
  with TStringGrid(Form.FindComponent('ObjectsGrid')) do
  begin
    Enabled := True;
    Cells[1, Row] := newClassName;
    Cells[2, Row] := '100';
  end;
  Python.SetJsonExif(ImagePath, GridObjectsToJsonString(Form));
  Functions.AssignImageAndDrawBoxes(Form, ImagePath);
end;

procedure TObjectsModule.DeleteObj(Form: TForm; ImagePath, FolderPath: string);
var
  i: integer;
begin
  with TStringGrid(Form.FindComponent('ObjectsGrid')) do
  if Functions.MyMessageDlg('Удалить объект №'+Cells[0, Row]+'?', mtConfirmation,
  [mbYes, mbNo], ['Да','Нет'], 'Подтверждение') = mrYes then
  begin
    if RowCount > 2 then
    begin
      DelRow(Row);
      for i:=1 to RowCount do
        Cells[0, i] := i.ToString;
      Python.SetJsonExif(ImagePath, GridObjectsToJsonString(Form));
      Row := 1;
    end
    else
    begin
      ResetObjectsGrid(Form);
      TPanel(Form.FindComponent('ProcessBottomPanel')).Visible := False;
      Python.SetJsonExif(ImagePath, '{"animals": ["None"], "date": "'+ImageShotDate+'"}');
      TLabel(Form.FindComponent('ImageObjectsLabel')).Caption := 'Объекты на изображении не найдены.';
    end;
    Functions.CalculateFolderImagesStates(FolderPath);
    FillObjectsGrid(Form, ImagePath);
    Functions.AssignImageAndDrawBoxes(Form, ImagePath);
  end;
end;

end.

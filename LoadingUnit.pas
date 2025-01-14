unit LoadingUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.WinXCtrls, Vcl.StdCtrls,
  Vcl.Imaging.GIFImg, Vcl.ExtCtrls, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage;

type
  TLoadingForm = class(TForm)
    Label1: TLabel;
    ActivityIndicator1: TActivityIndicator;
    Image1: TImage;
    Label3: TLabel;
    Image2: TImage;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LoadingForm: TLoadingForm;

implementation

uses
  PythonUnit, MainUnit;

{$R *.dfm}

procedure TLoadingForm.FormCreate(Sender: TObject);
begin
  SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0,
                       SWP_NoMove or SWP_NoSize);
end;

end.

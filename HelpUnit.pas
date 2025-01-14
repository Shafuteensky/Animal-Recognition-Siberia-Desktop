unit HelpUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Imaging.jpeg;

type
  THelp = class(TForm)
    Help: TPageControl;
    ProcessorPage: TTabSheet;
    TabSheet1: TTabSheet;
    Image1: TImage;
    GroupBox4: TGroupBox;
    Label25: TLabel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    TabSheet2: TTabSheet;
    ScrollBox3: TScrollBox;
    ScrollBox2: TScrollBox;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label40: TLabel;
    Label16: TLabel;
    Label22: TLabel;
    Image11: TImage;
    Label15: TLabel;
    Label33: TLabel;
    Image15: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Image2: TImage;
    Label41: TLabel;
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Help: THelp;

implementation

{$R *.dfm}



procedure THelp.FormResize(Sender: TObject);
begin
  Label41.AutoSize := False;
  Label32.AutoSize := False;
  Label3.AutoSize := False;
  Label31.AutoSize := False;
  Label30.AutoSize := False;
  Label22.AutoSize := False;
  Label33.AutoSize := False;
  Label41.AutoSize := True;
  Label32.AutoSize := True;
  Label3.AutoSize := True;
  Label31.AutoSize := True;
  Label30.AutoSize := True;
  Label22.AutoSize := True;
  Label33.AutoSize := True;
end;

end.

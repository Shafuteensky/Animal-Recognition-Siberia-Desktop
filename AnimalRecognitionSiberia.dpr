program AnimalRecognitionSiberia;

uses
  Windows,
  SysUtils,
  Vcl.Forms,
  SettingsUnit in 'SettingsUnit.pas' {Settings},
  HelpUnit in 'HelpUnit.pas' {Help},
  FunctionsUnit in 'FunctionsUnit.pas',
  AnimalsObjectsUnit in 'AnimalsObjectsUnit.pas',
  PythonUnit in 'PythonUnit.pas' {Python},
  LoadingUnit in 'LoadingUnit.pas' {LoadingForm},
  MainUnit in 'MainUnit.pas' {Main},
  CCR.Exif.BaseUtils in 'CCR\CCR.Exif.BaseUtils.pas',
  CCR.Exif.Consts in 'CCR\CCR.Exif.Consts.pas',
  CCR.Exif.IPTC in 'CCR\CCR.Exif.IPTC.pas',
  CCR.Exif.JpegUtils in 'CCR\CCR.Exif.JpegUtils.pas',
  CCR.Exif in 'CCR\CCR.Exif.pas',
  CCR.Exif.StreamHelper in 'CCR\CCR.Exif.StreamHelper.pas',
  CCR.Exif.TagIDs in 'CCR\CCR.Exif.TagIDs.pas',
  CCR.Exif.TiffUtils in 'CCR\CCR.Exif.TiffUtils.pas',
  CCR.Exif.XMPUtils in 'CCR\CCR.Exif.XMPUtils.pas';

{$R *.res}

begin
//  JclAppInstances.CheckSingleInstance;
  if CreateMutex(nil, True, '6EACD0BF-F3E0-44D9-91E7-47467B5A2B6A') = 0 then
  RaiseLastOSError;

  if GetLastError = ERROR_ALREADY_EXISTS then
    Exit;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMain, Main);
  Application.CreateForm(TSettings, Settings);
  Application.CreateForm(TPython, Python);
  Application.CreateForm(TLoadingForm, LoadingForm);
  Application.CreateForm(THelp, Help);
  Application.Run;
end.

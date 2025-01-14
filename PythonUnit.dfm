object Python: TPython
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Python'
  ClientHeight = 1035
  ClientWidth = 2181
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 121
    Top = 8
    Width = 143
    Height = 33
    Caption = #1055#1086#1076#1075#1086#1090#1086#1074#1082#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 438
    Top = 8
    Width = 277
    Height = 33
    Caption = #1056#1072#1089#1087#1086#1079#1085#1072#1074#1072#1085#1080#1077' '#1086#1073#1088#1072#1079#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 757
    Top = 8
    Width = 179
    Height = 33
    Caption = #1055#1086#1083#1091#1095#1080#1090#1100' Json'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 757
    Top = 199
    Width = 202
    Height = 33
    Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' Json'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Preparation: TMemo
    Left = 121
    Top = 47
    Width = 292
    Height = 604
    Lines.Strings = (
      'import sys'
      'import gc # '#1054#1095#1080#1089#1090#1082#1072' '#1084#1091#1089#1086#1088#1072
      'import os'
      'import glob  # '#1044#1083#1103' '#1080#1090#1077#1088#1072#1094#1080#1080' '#1087#1086' '#1092#1072#1081#1083#1072#1084' '#1074' '#1087#1072#1087#1082#1077
      'import json # '#1060#1086#1088#1084#1072#1090' '#1086#1073#1084#1077#1085#1072' '#1076#1072#1085#1085#1099#1084#1080
      'import PythonModule # '#1052#1086#1089#1090' Delphi-Python'
      
        'from PIL import Image, ImageOps, ImageDraw # '#1054#1073#1088#1072#1073#1086#1090#1082#1072' '#1080#1079#1086#1073#1088#1072#1078#1077#1085 +
        #1080#1103' '#1087#1077#1088#1077#1076' '#1086#1090#1087#1088#1072#1074#1082#1086#1081' '#1074' '#1053#1057
      'import piexif # '#1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1084#1077#1090#1072'-'#1076#1072#1085#1085#1099#1093' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1103
      'import numpy as np'
      'import torch'
      'from ultralytics import YOLO'
      'import cv2  # '#1040#1083#1075#1086#1088#1080#1090#1084#1099' '#1082#1086#1084#1087#1100#1102#1090#1077#1088#1085#1086#1075#1086' '#1079#1088#1077#1085#1080#1103
      ''
      'import pytesseract'
      'from dateparser.search import search_dates'
      'import re'
      ''
      'f = open("python.txt", "w")'
      'f.write(sys.version)'
      'f.write(str(sys.path))'
      'f.close()'
      ''
      '# '#1054#1095#1080#1097#1072#1077#1084' '#1087#1072#1084#1103#1090#1100
      'gc.collect()'
      'num_classes = 17'
      'class_names = ['
      '  '#39'Badger'#39','
      '  '#39'Birds'#39','
      '  '#39'Boar'#39','
      '  '#39'Brown bear'#39','
      '  '#39'Capercaillie'#39','
      '  '#39'Deer'#39','
      '  '#39'Dog'#39','
      '  '#39'Fox'#39','
      '  '#39'Human'#39','
      '  '#39'Lynx'#39','
      '  '#39'Moose'#39','
      '  '#39'Rabbit'#39','
      '  '#39'Reindeer'#39','
      '  '#39'Musk deer'#39','
      '  '#39'Siberian stag'#39','
      '  '#39'Wolf'#39','
      '  '#39'Wolverine'#39']'
      ''
      'def get_date(image):'
      
        '  footer = image[round((image.shape[0]/10)*9):image.shape[0], 0:' +
        'image.shape[1]]'
      '  header = image[0:round(image.shape[0]/10), 0:image.shape[1]]'
      '  info_image = np.concatenate((footer, header))'
      '  gray = cv2.cvtColor(info_image, cv2.COLOR_RGB2GRAY)'
      
        '  thresholded = cv2.threshold(gray, 230, 255, cv2.THRESH_BINARY)' +
        '[1]'
      '  denoised = cv2.medianBlur(thresholded, 3)'
      '  text = pytesseract.image_to_string(denoised)'
      '  regex = re.compile('#39'[^0-9.,:;/-]'#39')'
      '  text = regex.sub('#39' '#39', text)'
      '  dates = search_dates(text, settings={'#39'STRICT_PARSING'#39': True})'
      '  if dates != None:'
      '    img_date = dates[0][1].date().strftime("%d.%m.%Y")'
      '    return img_date'
      '  else:'
      '    return '#39'10.01.2001'#39
      ''
      'weights_path = PythonModule.appPath+'#39'weights//best.pt'#39
      
        'pytesseract.pytesseract.tesseract_cmd = PythonModule.appPath+'#39'te' +
        'sseract//tesseract.exe'#39
      '# '#1048#1075#1085#1086#1088#1080#1088#1086#1074#1072#1085#1080#1077' '#1079#1072#1084#1077#1095#1072#1085#1080#1103' '#1086' '#1076#1077#1083#1077#1085#1080#1080
      'np.seterr(divide='#39'ignore'#39', invalid='#39'ignore'#39')'
      ''
      '# '#1040#1088#1093#1080#1090#1077#1082#1090#1091#1088#1072' '#1084#1086#1076#1077#1083#1080
      'if __name__ == '#39'__main__'#39':'
      '    torch.cuda.empty_cache()'
      '    model = YOLO(weights_path)')
    TabOrder = 0
    WordWrap = False
  end
  object Recognition: TMemo
    Left = 438
    Top = 47
    Width = 292
    Height = 604
    Lines.Strings = (
      'folderPath = PythonModule.folderPath'
      'imageName = PythonModule.imageName'
      'pred_thrsh = PythonModule.pred_thrsh'
      ''
      'if __name__ == '#39'__main__'#39':'
      '    animals = []'
      
        '    image = Image.open(PythonModule.folderPath+PythonModule.imag' +
        'eName)'
      '    image = np.asarray(image)'
      '    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)'
      '    image_date = get_date(image)'
      '    predict_results = model.predict(image)'
      '    result = predict_results[0].cpu()'
      '    for box in result.boxes:'
      '        if box.conf.numpy()[0] > pred_thrsh: #>pred_thrsh'
      
        '            class_name = class_names[box.cls.numpy()[0].astype(i' +
        'nt)]'
      '            prob = int(box.conf.numpy()[0]*100)'
      '            box = box.xyxyn.numpy()[0].astype(float).tolist()'
      '            box = ['#39'%.4f'#39' % elem for elem in box]'
      
        '            animals.append({'#39'class'#39': class_name, '#39'prob'#39': prob, '#39 +
        'box'#39': box})'
      '            print(class_name)'
      '            print(prob)'
      '            print(box)'
      '    if len(animals) > 0:'
      
        '        data = {"animals": [animal for animal in animals], "date' +
        '": image_date}'
      '    else:'
      '        data = {"animals": ['#39'None'#39'], "date": image_date}'
      '    data_json = json.dumps(data)'
      '    zeroth_ifd = {piexif.ImageIFD.ImageDescription: data_json}'
      '    exif_bytes = piexif.dump({"0th": zeroth_ifd})'
      '    piexif.insert(exif_bytes, folderPath+imageName)'
      '    gc.collect()')
    TabOrder = 1
    WordWrap = False
  end
  object GetExifJson: TMemo
    Left = 757
    Top = 47
    Width = 292
    Height = 85
    Lines.Strings = (
      'exif_dict = piexif.load(PythonModule.imagePath)'
      'jsonString.Value = str(None)'
      'if piexif.ImageIFD.ImageDescription in exif_dict["0th"]:'
      '    try:'
      
        '        templates = json.loads(exif_dict["0th"][piexif.ImageIFD.' +
        'ImageDescription])'
      '        jsonString.Value = str(templates)'
      '    except:'
      '        jsonString.Value = str(None)'
      'else:'
      '    jsonString.Value = str(None)'
      ''
      ''
      '')
    TabOrder = 2
    WordWrap = False
  end
  object SetExifJson: TMemo
    Left = 757
    Top = 238
    Width = 292
    Height = 108
    Lines.Strings = (
      'jsonStr = PythonModule.jsonString'
      'zeroth_ifd = {piexif.ImageIFD.ImageDescription: jsonStr}'
      'exif_bytes = piexif.dump({"0th":zeroth_ifd})'
      'piexif.insert(exif_bytes, PythonModule.imagePath)'
      ''
      ''
      ''
      '')
    TabOrder = 3
    WordWrap = False
  end
  object PythonEngine: TPythonEngine
    AutoLoad = False
    RedirectIO = False
    Left = 41
    Top = 74
  end
  object PythonModule: TPythonModule
    Engine = PythonEngine
    ModuleName = 'PythonModule'
    Errors = <>
    Left = 40
    Top = 19
  end
  object JsonStringPyVar: TPythonDelphiVar
    Engine = PythonEngine
    Module = '__main__'
    VarName = 'jsonString'
    Left = 884
    Top = 146
  end
  object AnimalClassPyVar: TPythonDelphiVar
    Engine = PythonEngine
    Module = '__main__'
    VarName = 'animalClass'
    OnGetData = AnimalClassPyVarGetData
    OnSetData = AnimalClassPyVarSetData
    Left = 567
    Top = 664
  end
  object ObjectBoxPyVar: TPythonDelphiVar
    Engine = PythonEngine
    Module = '__main__'
    VarName = 'objectBox'
    Left = 1217
    Top = 666
  end
end

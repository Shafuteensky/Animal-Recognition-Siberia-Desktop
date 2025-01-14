class PythonModule:
  folderPath = 'H://Ергаки//TEST4//'
  imageName = '1.JPG'
  pred_thrsh = 50
  appPath = 'I://Workshop//Programming//Projects//Institute//Animal Recognition Siberia//ARS Desktop//Win64//Debug//res//'
  jsonString = {"animals": ['TEST'], "date": "23.05.2017"}
  imagePath = folderPath+imageName

class jsonString:
    Value = 0

# Подготовка =======================================================================================

import sys
import gc # Очистка мусора
import os
import glob  # Для итерации по файлам в папке
import json # Формат обмена данными
# import PythonModule # Мост Delphi-Python
from PIL import Image, ImageOps, ImageDraw # Обработка изображения перед отправкой в НС
import piexif # Редактирование мета-данных изображения
import numpy as np
import torch
from ultralytics import YOLO
import cv2  # Алгоритмы компьютерного зрения

import pytesseract
from dateparser.search import search_dates
import re

f = open("python.txt", "w")
f.write(sys.version)
f.write(str(sys.path))
f.close()

# Очищаем память
gc.collect()
num_classes = 17
class_names = [
  'Badger',
  'Birds',
  'Boar',
  'Brown bear',
  'Capercaillie',
  'Deer',
  'Dog',
  'Fox',
  'Human',
  'Lynx',
  'Moose',
  'Rabbit',
  'Reindeer',
  'Musk deer',
  'Siberian stag',
  'Wolf',
  'Wolverine']

def get_date(image):
  footer = image[round((image.shape[0]/10)*9):image.shape[0], 0:image.shape[1]]
  header = image[0:round(image.shape[0]/10), 0:image.shape[1]]
  info_image = np.concatenate((footer, header))
  gray = cv2.cvtColor(info_image, cv2.COLOR_RGB2GRAY)
  thresholded = cv2.threshold(gray, 230, 255, cv2.THRESH_BINARY)[1]
  denoised = cv2.medianBlur(thresholded, 3)
  text = pytesseract.image_to_string(denoised)
  regex = re.compile('[^0-9.,:;/-]')
  text = regex.sub(' ', text)
  dates = search_dates(text, settings={'STRICT_PARSING': True})
  if dates != None:
    img_date = dates[0][1].date().strftime("%d.%m.%Y")
    return img_date
  else:
    return '10.01.2001'

weights_path = PythonModule.appPath+'weights//best.pt'
pytesseract.pytesseract.tesseract_cmd = PythonModule.appPath+'tesseract//tesseract.exe'
# Игнорирование замечания о делении
np.seterr(divide='ignore', invalid='ignore')

# Архитектура модели
if __name__ == '__main__':
    torch.cuda.empty_cache()
    model = YOLO(weights_path)

# Распознавание =======================================================================================

folderPath = PythonModule.folderPath
imageName = PythonModule.imageName
pred_thrsh = PythonModule.pred_thrsh

if __name__ == '__main__':
    animals = []
    image = Image.open(PythonModule.folderPath+PythonModule.imageName)
    image = np.asarray(image)
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    image_date = get_date(image)
    predict_results = model.predict(image)
    result = predict_results[0].cpu()
    for box in result.boxes:
        if box.conf.numpy()[0] > pred_thrsh: #>pred_thrsh
            class_name = class_names[box.cls.numpy()[0].astype(int)]
            prob = int(box.conf.numpy()[0]*100)
            box = box.xyxyn.numpy()[0].astype(float).tolist()
            box = ['%.4f' % elem for elem in box]
            animals.append({'class': class_name, 'prob': prob, 'box': box})
            print(class_name)
            print(prob)
            print(box)
    if len(animals) > 0:
        data = {"animals": [animal for animal in animals], "date": image_date}
    else:
        data = {"animals": ['None'], "date": image_date}
    data_json = json.dumps(data)
    zeroth_ifd = {piexif.ImageIFD.ImageDescription: data_json}
    exif_bytes = piexif.dump({"0th": zeroth_ifd})
    piexif.insert(exif_bytes, folderPath+imageName)
    gc.collect()

# Получить JSON =======================================================================================

exif_dict = piexif.load(PythonModule.imagePath)
jsonString.Value = str(None)
if piexif.ImageIFD.ImageDescription in exif_dict["0th"]:
    try:
        templates = json.loads(exif_dict["0th"][piexif.ImageIFD.ImageDescription])
        jsonString.Value = str(templates)
    except:
        jsonString.Value = str(None)
else:
    jsonString.Value = str(None)

# Установить JSON =======================================================================================

jsonStr = PythonModule.jsonString
zeroth_ifd = {piexif.ImageIFD.ImageDescription: jsonStr}
exif_bytes = piexif.dump({"0th":zeroth_ifd})
piexif.insert(exif_bytes, PythonModule.imagePath)


import cv2
from PIL import Image
from tensorflow.keras.models import Sequential, save_model, load_model
import matplotlib.pyplot as plt
import numpy as np
import itertools
from keytotext import pipeline
import random
import shutil

# read files
def predict(filename):
    fileD = open("sentimentsText.txt", "r")
    labels = {}
    data = []
    for x in fileD:
      data.append(x)

    for i in data:
      param = i.split('(')
      adjust = param[0][:len(param[0])-1]
      vectorstring = param[1].replace('(','').replace(')','').replace('\n','')
      vector = [(int(j)-2) for j in vectorstring.split(',')]
      labels[adjust] = vector
    class_names =[]

    for key in labels.keys():
      class_names.append(key)


    # Load image, grayscale, Gaussian blur, Otsu's threshold, dilate
    image = cv2.imread(filename)
    original = image.copy()
    gray = cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)
    blur = cv2.GaussianBlur(gray, (5,5), 0)
    thresh = cv2.threshold(blur, 0, 255, cv2.THRESH_BINARY_INV + cv2.THRESH_OTSU)[1]
    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (7,7))
    dilate = cv2.dilate(thresh, kernel, iterations=1)

    # Find contours, obtain bounding box coordinates, and extract ROI
    cnts = cv2.findContours(dilate, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    cnts = cnts[0] if len(cnts) == 2 else cnts[1]
    image_number = 0
    imgs=[]
  #  !mkdir imgs
    for c in cnts:
        x,y,w,h = cv2.boundingRect(c)
        cv2.rectangle(image, (x, y), (x + w, y + h), (36,255,12), 2)
        ROI = original[y:y+h, x:x+w]
        cv2.imwrite("X_{}.png".format(image_number), ROI)
        imgs.append("X_"+str(image_number)+".png")
        image_number += 1



    objects=[]
    model1 = load_model('mm', compile = True)
    for i in imgs:
        img_arrayX = cv2.imread(i)
        new_arrayX = cv2.cvtColor(img_arrayX, cv2.COLOR_BGR2GRAY)
        new_arrayX = cv2.resize(new_arrayX, (28,28),interpolation = cv2.INTER_AREA).astype('float32')
        new_arrayX = new_arrayX.reshape(28,28,1)

        img = new_arrayX
        pred = model1.predict(np.expand_dims(img, axis=0))[0]

        ind = (-pred).argsort()[:1]

        latex = [class_names[x] for x in ind]
        objects.append(latex)


    objects = list(np.concatenate(objects).flat)

    objects = [*set(objects)]


    S_Val = []
    for obj in objects:
      for key, value in labels.items():
        if obj == key :
          S_Val.append (value)

    S_Val = np.array(S_Val)


    S_Values = []

    S_Values = S_Val.sum(axis=0)


    max = np.max(S_Values)

    max_ind = []
    max_ind2 = []
    for i in range (6):
      if S_Values[i] == max :
        max_ind.append(i)


    if (len(max_ind)) < 2 :
      for i in range (6):
        if S_Values[i] == max :
          S_Values[i] = -99

      max2 = np.max(S_Values)

      for i in range (6):
        if S_Values[i] == max2 :
          max_ind.append(i)


    emotions = {}

    emotions[0] = ['pleasure', 'happy','delight','joy','satisfaction','amusement']
    emotions[1] = ['displeasure', 'disgust', 'angry','aggravation','irritation','annoyance']
    emotions[2] = ['strain','stress','anxiety','tension']
    emotions[3] = ['relaxation','calm','tranquility','ease','peace']
    emotions[4] = ['excitement','enthusiasm','exhiliration','energy']
    emotions[5] = ['quiescence','depression','melancholy','sadness']

    keyword=[]
    for x in max_ind:
      for key,value in emotions.items():
        if x == key:
          ee = random.choice(value)
          keyword.append(ee)
    #keyword = [_ for i in range(len(keyword)) for _ in keyword[i]]
    #print(keyword)
    keywords = []
    keywords = objects + keyword


    nlp = pipeline("mrm8488/t5-base-finetuned-common_gen")


    Sentence = nlp(keywords)
    print(Sentence)

    remain = []

    for x in keywords:
      if x not in Sentence:
        remain.append(x)

    nlp(remain)

    
   # shutil.rmtree(r'imgs', ignore_errors=True)
    return Sentence
import cv2
import os
import numpy as np


def applyEqualizeHist(image_path, image_name):
    # Lendo imagem
    img = cv2.imread(image_path, cv2.IMREAD_COLOR)

    # Não equalizar imagens da folha de papel
    if "_fl" not in image_name: 
        # Convertendo para HSV
        hsv_img = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)

        # Dividindo a imagem HSV em diferentes canais
        h, s, v = cv2.split(hsv_img)

        # Aplicando equalização de histograma no canal V
        v_equalized = cv2.equalizeHist(v)

        # Unificando os canais H, S e V com equalização aplicada
        hsv_img_equalized = cv2.merge((h, s, v_equalized))

        # Convertendo imagem HSV equalizada em RGB
        img_equalized = cv2.cvtColor(hsv_img_equalized, cv2.COLOR_HSV2BGR)
    
        # Salva imagem (removendo os 4 ultimos caracteres pertencentes ao formato do arquivo)
        # cv2.imwrite('./Equalizadas/{}.jpg'.format(image_name[:-4]), img_equalized)
        cv2.imwrite('./Equalizadas/{}'.format(image_name), img_equalized)
    else:
        cv2.imwrite('./Equalizadas/{}'.format(image_name), img)

# Percorrer pasta de imagens e aplicar função
for file in os.listdir("./Imagens1111"):
    if file.endswith(".png"):
        print(file)
        applyEqualizeHist(os.path.join("./Imagens1111", file), file)

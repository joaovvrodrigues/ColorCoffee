import cv2
import os
import numpy as np


def applyMedianBlur(image_path, image_name):
    # Lendo imagem
    img = cv2.imread(image_path)

    # Aplicando suavização pela mediana
    median = cv2.medianBlur(img, 9)

    # Salva imagem (removendo os 4 ultimos caracteres pertencentes ao formato do arquivo)
    # cv2.imwrite('./Suavizadas1/{}.jpg'.format(image_name[:-4]), median)
    cv2.imwrite('./Suavizadas1/{}'.format(image_name), median)


# Percorrer pasta de imagens e aplicar função
for file in os.listdir(".\\Equalizadas"):
    if file.endswith(".png"):
        print(file)
        applyMedianBlur(os.path.join(".\\Equalizadas", file), file)

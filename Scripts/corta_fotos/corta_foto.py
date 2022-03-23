import cv2
import os

x = 1030
y = 1489
h = (1993 - x)

for arquivo in os.listdir(path='.\\\imagens\\'):
    img = cv2.imread(".\\\imagens\\{}".format(arquivo))
    crop_img = img[y:y+h, x:x+h]
    cv2.imwrite(".\\\crop\\{}".format(arquivo), crop_img)
import cv2
import os

x = 1795
y = 1269
h = (2817 - 1795)

for arquivo in os.listdir(path='.\\\imagens\\'):
    img = cv2.imread(".\\\imagens\\{}".format(arquivo))
    crop_img = img[y:y+h, x:x+h]
    cv2.imwrite(".\\\crop\\{}".format(arquivo), crop_img)
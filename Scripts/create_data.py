import cv2
import numpy as np
import os
import csv

# Normal H,S,V: (0-360,0-100%,0-100%)
# OpenCV H,S,V: (0-180,0-255 ,0-255)


def getMeanRGB(image_path):
    rgb_img = cv2.imread(image_path)
    R, G, B = cv2.split(rgb_img)

    return ((round(np.mean(R)), round(np.mean(G)), round(np.mean(B))))


def getMeanHSV(image_path):
    rgb_img = cv2.imread(image_path)
    hsv_img = cv2.cvtColor(rgb_img, cv2.COLOR_RGB2HSV)
    H, S, V = cv2.split(hsv_img)

    return ((round(np.mean(H)), round(np.mean(S)), round(np.mean(V))))


def createData():
    id_count = 0
    devices = ['iPhone 8', 'Motorola X4', 'Redmi 5A', 'Xiaomi Mi9', 'Lumix']
    lighting_conditions = ['Luz', 'Flash', 'Externo', 'Sombra']
    types = ['Folha', 'Cafe']

    header = ['ID', 'Device', 'Height', 'Width', 'Num_sample', 'Lighting_condition', 'R_mean', 'G_mean', 'B_mean', 'Paper_R_mean',
              'Paper_G_mean', 'Paper_B_mean', 'H_mean', 'S_mean', 'V_mean', 'Paper_H_mean', 'Paper_S_mean', 'Paper_V_mean', 'Agtron_value', 'File', 'Path']

    data = []

    for device in devices:
        print("### {} ###".format(device))
        for condition in lighting_conditions:
            print("=== {} ===".format(condition))
            data_papers = []
            for option in types:
                print("--- {} ---".format(option))
                for file in os.listdir(".\photos\{}\{}\{}".format(device, condition, option)):
                    img_path = os.path.join(
                        ".\photos\{}\{}\{}".format(device, condition, option), file)
                    img = cv2.imread(img_path)

                    if option == 'Folha':
                        R, G, B = getMeanRGB(img_path)
                        H, S, V = getMeanHSV(img_path)
                        data_papers.append([R, G, B, H, S, V])
                    else:
                        print(file)
                        # PORQUE NÃO TEM EXPERIMENTO 1
                        if(device == "Lumix"):
                            paper = data_papers[int(file[3]) - 2]
                        else:
                            paper = data_papers[int(file[3]) - 1]

                        height, width, channels = img.shape

                        R, G, B = getMeanRGB(img_path)
                        H, S, V = getMeanHSV(img_path)

                        data.append([id_count, device, height,
                                    width, file[3], condition, R, G, B, paper[0], paper[1], paper[2], H, S, V, paper[3], paper[4], paper[5], file[0:2], file, img_path])

                        id_count = id_count + 1

    return header, data


def writeCSV(header, data, name):
    with open('./data/{}.csv'.format(name), 'w', encoding='UTF8', newline='') as f:
        writer = csv.writer(f)
        # Escreve o cabeçalho (header)
        writer.writerow(header)
        # Escreve todas as linhas (data)
        writer.writerows(data)


def testeMeanShiftFiltering():
    image_path = "photos\\iPhone 8\\Flash\\Cafe\\25_1.png"
    img = cv2.imread(image_path)

    hsv_img = cv2.cvtColor(img, cv2.COLOR_RGB2HSV)

    cv2.imshow('aaa', hsv_img)

    dst = cv2.pyrMeanShiftFiltering(hsv_img, 10, 50)

    cv2.imshow('bbb', dst)
    cv2.waitKey()


print('========== EXTRACTING DATA ==========')
header, data = createData()
writeCSV(header, data, 'coffee_data')
print('================ DONE ================')

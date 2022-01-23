import cv2
import numpy as np
import os
import csv

# Normal H,S,V: (0-360,0-100%,0-100%)
# OpenCV H,S,V: (0-180,0-255 ,0-255)


def getMeanRGB(image_path):
    rgb_img = cv2.imread(image_path)
    # wb = cv2.xphoto.createGrayworldWB()
    # wb.setSaturationThreshold(0.2)
    # rgb_img = wb.balanceWhite(rgb_img)
    # rgb_img = cv2.medianBlur(src=rgb_img, ksize=9)
    R, G, B = cv2.split(rgb_img)

    return ((round(np.mean(R)), round(np.mean(G)), round(np.mean(B))))


def getMeanHSV(image_path):
    rgb_img = cv2.imread(image_path)
    # wb = cv2.xphoto.createGrayworldWB()
    # wb.setSaturationThreshold(0.2)
    # rgb_img = wb.balanceWhite(rgb_img)
    # rgb_img = cv2.medianBlur(src=rgb_img, ksize=9)
    hsv_img = cv2.cvtColor(rgb_img, cv2.COLOR_RGB2HSV)
    H, S, V = cv2.split(hsv_img)

    return ((round(np.mean(H)), round(np.mean(S)), round(np.mean(V))))

def white_balance(img):
    result = cv2.cvtColor(img, cv2.COLOR_BGR2LAB)
    avg_a = np.average(result[:, :, 1])
    avg_b = np.average(result[:, :, 2])
    result[:, :, 1] = result[:, :, 1] - ((avg_a - 128) * (result[:, :, 0] / 255.0) * 1.1)
    result[:, :, 2] = result[:, :, 2] - ((avg_b - 128) * (result[:, :, 0] / 255.0) * 1.1)
    result = cv2.cvtColor(result, cv2.COLOR_LAB2BGR)
    return result

def getMeanRGBequalized(image_path):
    rgb_img = cv2.imread(image_path)
    rgb_img = cv2.medianBlur(src=rgb_img, ksize=9)
    # Convertendo para HSV
    hsv_img = cv2.cvtColor(rgb_img, cv2.COLOR_BGR2HSV)

    # Dividindo a imagem HSV em diferentes canais
    h, s, v = cv2.split(hsv_img)

    # Aplicando equalização de histograma no canal V
    v_equalized = cv2.equalizeHist(v)

    # Unificando os canais H, S e V com equalização aplicada
    hsv_img_equalized = cv2.merge((h, s, v_equalized))

    # Convertendo imagem HSV equalizada em RGB
    img_equalized = cv2.cvtColor(hsv_img_equalized, cv2.COLOR_HSV2BGR)
    R, G, B = cv2.split(img_equalized)

    return ((round(np.mean(R)), round(np.mean(G)), round(np.mean(B))))

def getMeanHSVequalized(image_path):
    rgb_img = cv2.imread(image_path)
    rgb_img = cv2.medianBlur(src=rgb_img, ksize=9)
    hsv_img = cv2.cvtColor(rgb_img, cv2.COLOR_RGB2HSV)
    H, S, V = cv2.split(hsv_img)
    v_equalized = cv2.equalizeHist(V)

    return ((round(np.mean(H)), round(np.mean(S)), round(np.mean(v_equalized))))

def getMeanLAB(image_path):
    rgb_img = cv2.imread(image_path)
    lab_img = cv2.cvtColor(rgb_img, cv2.COLOR_RGB2LAB)
    L, A, B = cv2.split(lab_img)

    return ((round(np.mean(L)), round(np.mean(A)), round(np.mean(B))))


def getMeanGray(image_path):
    rgb_img = cv2.imread(image_path)
    gray_img = cv2.cvtColor(rgb_img, cv2.COLOR_RGB2GRAY)
    gray = cv2.split(gray_img)
    return round(np.mean(gray))


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
                        R, G, B = getMeanRGBequalized(img_path)
                        H, S, V = getMeanHSVequalized(img_path)
                        data_papers.append([R, G, B, H, S, V])
                    else:
                        print(file)
                        # PORQUE NÃO TEM EXPERIMENTO 1
                        if(device == "Lumix"):
                            paper = data_papers[int(file[3]) - 2]
                        else:
                            paper = data_papers[int(file[3]) - 1]

                        height, width, channels = img.shape

                        R, G, B = getMeanRGBequalized(img_path)
                        H, S, V = getMeanHSVequalized(img_path)

                        data.append([id_count, device, height,
                                    width, file[3], condition, R, G, B, paper[0], paper[1], paper[2], H, S, V, paper[3], paper[4], paper[5], 'Agtron {}'.format(file[0:2]), file, img_path])

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

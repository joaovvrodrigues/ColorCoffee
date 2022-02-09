import cv2
import numpy as np
import os
import csv
from sklearn.cluster import MiniBatchKMeans

# Normal H,S,V: (0-360,0-100%,0-100%)
# OpenCV H,S,V: (0-180,0-255 ,0-255)


def getMeanRGB(img, equalizar=False):

    if(equalizar):
        # Convertendo para HSV
        hsv_img = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)

        # Dividindo a imagem HSV em diferentes canais
        h, s, v = cv2.split(hsv_img)

        # Aplicando equalização de histograma no canal V
        v_equalized = cv2.equalizeHist(v)

        # Unificando os canais H, S e V com equalização aplicada
        hsv_img_equalized = cv2.merge((h, s, v_equalized))

        # Convertendo imagem HSV equalizada em RGB
        img = cv2.cvtColor(hsv_img_equalized, cv2.COLOR_HSV2BGR)

    R, G, B = cv2.split(img)

    return (R, G, B)


def getMeanHSV(rgb_img, equalizar=False):
    hsv_img = cv2.cvtColor(rgb_img, cv2.COLOR_BGR2HSV)
    H, S, V = cv2.split(hsv_img)

    if(equalizar):
        v_equalized = cv2.equalizeHist(V)
        return (H, S, v_equalized)
    else:
        return (H, S, V)


def colorQuantization(rgb_img, n_clusters=8):
    # Pega tamanho da imagem
    (h, w) = rgb_img.shape[:2]

    # converte a imagem do espaço de cores RGB para o espaço de cores L*a*b* 
    # -- já que estaremos agrupando usando k-means # que é baseado na distância euclidiana, usaremos o 
    # L*a* b* espaço de cor onde a distância euclidiana implica 
    # significado perceptivo
    img = cv2.cvtColor(rgb_img, cv2.COLOR_BGR2LAB)
    
    # reshape the image into a feature vector so that k-means
    # can be applied
    img = img.reshape((img.shape[0] * img.shape[1], 3))

    clt = MiniBatchKMeans(n_clusters=n_clusters, random_state = 42)
    labels = clt.fit_predict(img)

    # the image reduced to colors
    quant = clt.cluster_centers_.astype("uint8")[labels]

    # reshape the feature vectors to imgs
    quant = quant.reshape((h, w, 3))

    # convert from L*a*b* to RGB
    quant = cv2.cvtColor(quant, cv2.COLOR_LAB2BGR)

    return quant


def createData(filtros):
    devices = ['iPhone 8', 'Motorola X4', 'Redmi 5A', 'Xiaomi Mi9']
    lighting_conditions = ['Luz', 'Flash', 'Externo', 'Sombra']
    types = ['Folha', 'Cafe']

    header_RGB = ['RGB_medio_cafe', 'R_medio_cafe', 'G_medio_cafe', 'B_medio_cafe', 'RGB_std_cafe', 'R_std_cafe', 'G_std_cafe', 'B_std_cafe',
                  'RGB_medio_folha', 'R_medio_folha', 'G_medio_folha', 'B_medio_folha', 'RGB_std_folha', 'R_std_folha', 'G_std_folha', 'B_std_folha', 'Agtron']
    header_HSV = ['HSV_medio_cafe', 'H_medio_cafe', 'S_medio_cafe', 'V_medio_cafe', 'HSV_std_cafe', 'H_std_cafe', 'S_std_cafe', 'V_std_cafe',
                  'HSV_medio_folha', 'H_medio_folha', 'S_medio_folha', 'V_medio_folha', 'HSV_std_folha', 'H_std_folha', 'S_std_folha', 'V_std_folha', 'Agtron']

    header_geral = ['RGB_medio_cafe', 'R_medio_cafe', 'G_medio_cafe', 'B_medio_cafe', 'RGB_std_cafe', 'R_std_cafe', 'G_std_cafe', 'B_std_cafe',
                    'RGB_medio_folha', 'R_medio_folha', 'G_medio_folha', 'B_medio_folha', 'RGB_std_folha', 'R_std_folha', 'G_std_folha', 'B_std_folha', 'HSV_medio_cafe', 'H_medio_cafe', 'S_medio_cafe', 'V_medio_cafe', 'HSV_std_cafe', 'H_std_cafe', 'S_std_cafe', 'V_std_cafe',
                    'HSV_medio_folha', 'H_medio_folha', 'S_medio_folha', 'V_medio_folha', 'HSV_std_folha', 'H_std_folha', 'S_std_folha', 'V_std_folha', 'Agtron']

    header_geral_s_papel = ['RGB_medio_cafe', 'R_medio_cafe', 'G_medio_cafe', 'B_medio_cafe', 'RGB_std_cafe', 'R_std_cafe', 'G_std_cafe', 'B_std_cafe',
                            'RGB_medio_folha', 'RGB_std_folha', 'HSV_medio_cafe', 'H_medio_cafe', 'S_medio_cafe', 'V_medio_cafe', 'HSV_std_cafe', 'H_std_cafe', 'S_std_cafe', 'V_std_cafe',
                            'HSV_medio_folha', 'HSV_std_folha', 'Agtron']

    informacoes_adc = []

    data = []

    for device in devices:
        print("Dispositivo: {}".format(device))
        for condition in lighting_conditions:
            print("   Iluminação: {}".format(condition))

            todos_papeis_RGB = []
            todos_papeis_HSV = []

            for option in types:
                print("     Tipo: {}".format(option))
                for file in os.listdir(".\photos\{}\{}\{}".format(device, condition, option)):
                    img_path = os.path.join(
                        ".\photos\{}\{}\{}".format(device, condition, option), file)

                    img = cv2.imread(img_path)

                    if(filtros):
                        # MEDIAN BLUR
                        img = cv2.medianBlur(src=img, ksize=9)

                        # Color quantization
                        img = colorQuantization(img, n_clusters=6)


                    if option == 'Folha':
                        R_f, G_f, B_f = getMeanRGB(img, equalizar=filtros)
                        media_folha_RGB = np.mean([R_f, G_f, B_f])
                        desvio_folha_RGB = np.std([R_f, G_f, B_f])

                        H_f, S_f, V_f = getMeanHSV(img, equalizar=filtros)
                        media_folha_HSV = np.mean([H_f, S_f, V_f])
                        desvio_folha_HSV = np.std([H_f, S_f, V_f])

                        # gray_f = getMeanGray(img)
                        todos_papeis_RGB.append([R_f, G_f, B_f])
                        todos_papeis_HSV.append([H_f, S_f, V_f])
                    else:
                        R_c, G_c, B_c = getMeanRGB(img, equalizar=filtros)
                        H_c, S_c, V_c = getMeanHSV(img, equalizar=filtros)
                        # gray_coffe = getMeanGray(img)

                        papel_amostra_atual_RGB = todos_papeis_RGB[int(
                            file[3]) - 1]
                        R_f = papel_amostra_atual_RGB[0]
                        G_f = papel_amostra_atual_RGB[1]
                        B_f = papel_amostra_atual_RGB[2]

                        papel_amostra_atual_HSV = todos_papeis_HSV[int(
                            file[3]) - 1]
                        H_f = papel_amostra_atual_HSV[0]
                        S_f = papel_amostra_atual_HSV[1]
                        V_f = papel_amostra_atual_HSV[2]

                        media_cafe_RGB = np.mean([R_c, G_c, B_c])
                        desvio_cafe_RGB = np.std([R_c, G_c, B_c])

                        media_cafe_HSV = np.mean([H_c, S_c, V_c])
                        desvio_cafe_HSV = np.std([H_c, S_c, V_c])

                        # geral_list = [media_cafe_RGB, np.mean(R_c), np.mean(G_c), np.mean(B_c), desvio_cafe_RGB, np.std(R_c), np.std(G_c), np.std(B_c), media_folha_RGB, np.mean(R_f), np.mean(G_f), np.mean(B_f), desvio_folha_RGB, np.std(R_f), np.std(G_f), np.std(B_f), media_cafe_HSV, np.mean(H_c), np.mean(S_c), np.mean(V_c), desvio_cafe_HSV, np.std(H_c), np.std(S_c), np.std(
                        #     V_c), media_folha_HSV, np.mean(H_f), np.mean(S_f), np.mean(V_f), desvio_folha_HSV, np.std(H_f), np.std(S_f), np.std(V_f)]

                        geral_list = [media_cafe_RGB, np.mean(R_c), np.mean(G_c), np.mean(B_c), desvio_cafe_RGB, np.std(R_c), np.std(G_c), np.std(B_c), media_folha_RGB, desvio_folha_RGB, media_cafe_HSV, np.mean(H_c), np.mean(S_c), np.mean(V_c), desvio_cafe_HSV, np.std(H_c), np.std(S_c), np.std(
                            V_c), media_folha_HSV, desvio_folha_HSV]
                        
                        # data_aux = [media_cafe_RGB, np.mean(R_c), np.mean(G_c), np.mean(B_c), desvio_cafe_RGB, np.std(R_c), np.std(G_c), np.std(
                        #     B_c), media_folha_RGB, np.mean(R_f), np.mean(G_f), np.mean(B_f), desvio_folha_RGB, np.std(R_f), np.std(G_f), np.std(B_f)]
                            
                        round_all = [round(num, 3) for num in geral_list]

                        round_all.append('Agtron {}'.format(file[0:2]))

                        # data_RGB.append([media_cafe_RGB, np.mean(R_c), np.mean(G_c), np.mean(B_c), desvio_cafe_RGB, np.std(R_c), np.std(G_c), np.std(
                        #     B_c), media_folha_RGB, np.mean(R_f), np.mean(G_f), np.mean(B_f), desvio_folha_RGB, np.std(R_f), np.std(G_f), np.std(B_f), 'Agtron {}'.format(file[0:2])])

                        # data_HSV.append([media_cafe_HSV, np.mean(H_c), np.mean(S_c), np.mean(V_c), desvio_cafe_HSV, np.std(H_c), np.std(S_c), np.std(
                        #     V_c), media_folha_HSV, np.mean(H_f), np.mean(S_f), np.mean(V_f), desvio_folha_HSV, np.std(H_f), np.std(S_f), np.std(V_f), 'Agtron {}'.format(file[0:2])])

                        data.append(round_all)
            print('\n')
        print('\n')
    return header_geral_s_papel,  data


def writeCSV(header, data, name):
    with open('./data/{}.csv'.format(name), 'w', encoding='UTF8', newline='') as f:
        writer = csv.writer(f)
        # Escreve o cabeçalho (header)
        writer.writerow(header)
        # Escreve todas as linhas (data)
        writer.writerows(data)

def exportarExemploFiltro():
    image_path = "photos\\Xiaomi Mi9\\Flash\\Cafe\\85_1.png"

    # # Imagem normal
    img = cv2.imread(image_path)
    cv2.imshow('Normal', img)
    cv2.waitKey(0)
    cv2.imwrite('./cafe_1.png', img)

    # # MEDIAN BLUR
    img = cv2.medianBlur(src=img, ksize=9)
    cv2.imshow('medianBlur', img)
    cv2.waitKey(0)
    cv2.imwrite('./cafe_2.png', img)

    # # Color quantization
    img = colorQuantization(img, n_clusters=6)
    cv2.imshow('Quant8', img)
    cv2.waitKey(0)
    cv2.imwrite('./cafe_3.png', img)

    # # Equalização de Histograma
    hsv_img = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    h, s, v = cv2.split(hsv_img)
    v_equalized = cv2.equalizeHist(v)
    hsv_img_equalized = cv2.merge((h, s, v_equalized))

    img = cv2.cvtColor(hsv_img_equalized, cv2.COLOR_HSV2BGR)
    cv2.imshow('hsv_img_equalized', img)
    cv2.waitKey(0)
    cv2.imwrite('./cafe_4.png', img)
    cv2.destroyAllWindows()


print('\n========== EXTRACTING DATA ==========\n')

nomeArq = 'all_semfiltro'
filtros = True
header, data = createData(filtros)

if(filtros):
    nomeArq = 'all_comfiltro'

writeCSV(header, data, nomeArq)

print('\n================ DONE ================\n')

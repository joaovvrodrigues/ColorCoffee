import cv2
import numpy as np
import csv

DOWN_WIDTH = 128
DOWN_HEIGHT = 128
TOTAL_IMAGES = 84


def read_img(img_name):
    img = cv2.imread(img_name, cv2.IMREAD_COLOR)
    return img


def display_img(label, img):
    # Mostrando a imagem dentro de uma janela
    cv2.imshow(label, img)
    cv2.waitKey()


def downscale_img(img):
    # Alterando o tamanho da imagem
    down_points = (DOWN_WIDTH, DOWN_HEIGHT)
    resized_down = cv2.resize(img, down_points, interpolation=cv2.INTER_LINEAR)
    return resized_down


def img_shape(img):
    # Pegando altura e largura da imagem
    h, w, c = img.shape
    return h, w


def crop_img(img):
    # Mostrando proporções
    # h, w = img_shape(img)
    # print('Original size: {}x{}'.format(h, w))

    # Cortando a imagem, pegando uma imagem 128x128 e extraindo o meio da imagem.
    # cropped_image = img[30:80, 30:80] # 50x50
    cropped_image = img[30:100, 30:100]  # 70x70

    # Mostrando novas proporções
    # h, w = img_shape(cropped_image)
    # print('Resized: {}x{}'.format(h, w))

    return cropped_image


def convert_LAB(img):
    # Convertendo para espaço de cor LAB
    img_LAB = cv2.cvtColor(img, cv2.COLOR_BGR2LAB)
    return img_LAB


def convert_HSV(img):
    # Convertendo para espaço de cor HSV
    img_HSV = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    return img_HSV


def median_blur(img):
    # Median blur: No desfoque médio, cada pixel na imagem de origem é substituído pelo valor médio dos pixels da imagem na área do kernel.
    median_blur_img = cv2.medianBlur(src=img, ksize=5)
    return median_blur_img


def split_channel(img):
    # Separando os canais dos espaços de cores
    channel_0 = np.array([])
    channel_1 = np.array([])
    channel_2 = np.array([])

    c_0 = img[:, :, 0]
    c_0 = c_0.reshape(c_0.shape[0]*c_0.shape[1])

    c_1 = img[:, :, 1]
    c_1 = c_1.reshape(c_1.shape[0]*c_1.shape[1])

    c_2 = img[:, :, 2]
    c_2 = c_2.reshape(c_2.shape[0]*c_2.shape[1])

    channel_0 = np.append(channel_0, c_0)
    channel_1 = np.append(channel_1, c_1)
    channel_2 = np.append(channel_2, c_2)

    # return channel_0, channel_1, channel_2
    return int(np.mean(channel_0)), int(np.mean(channel_1)), int(np.mean(channel_2))


def create_data(HSV=False):
    count = 0
    data = []

    if HSV:
        header = ['H_mean', 'S_mean', 'V_mean', 'Agtron']
    else:
        header = ['R_mean', 'G_mean', 'B_mean', 'Agtron']

    with open('./data/agtron_values.txt') as lines:
        for line in lines:
            count += 1
            img = read_img('./photos/{}.png'.format(count))
            img_cropped = crop_img(img)

            if HSV:
                H, S, V = split_channel(convert_HSV(img_cropped))
                data.append([H, S, V, 'Agtron {}'.format(line.strip())])
            else:
                B, G, R = split_channel(img_cropped)
                data.append([R, G, B, 'Agtron {}'.format(line.strip())])

    print('{} dados processados!'.format(count))

    return header, data


def create_CSV(header, data, name):
    with open('./data/{}.csv'.format(name), 'w', encoding='UTF8', newline='') as f:
        writer = csv.writer(f)
        # Escreve o cabeçalho (header)
        writer.writerow(header)
        # Escreve todas as linhas (data)
        writer.writerows(data)


def main():
    # header, data = create_data()
    # create_CSV(header, data, 'coffe_mean_rgb')

    # header, data = create_data(True)
    # create_CSV(header, data, 'coffe_mean_hsv')

    img = read_img('./photos/1636732274361.png')

    H, S, V = split_channel(convert_HSV(img))
    B, G, R = split_channel(img)

    print(R,G,B)
    print(H,S,V)


main()
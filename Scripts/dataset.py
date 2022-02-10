import cv2
import numpy as np
import os
import csv
from sklearn.cluster import MiniBatchKMeans

# Esconde os warnings
import warnings

# Parametros
RANDOM_STATE = 42
DEBUG_PRINT = False
DISPOSITIVOS = ['iPhone 8', 'Motorola X4', 'Redmi 5A', 'Xiaomi Mi9']
LUZ = ['Luz', 'Flash']  # , 'Externo', 'Sombra']
TIPO = ['Folha', 'Cafe']
HEADER = ['RGB_medio_cafe', 'R_medio_cafe', 'G_medio_cafe', 'B_medio_cafe', 'RGB_std_cafe', 'R_std_cafe', 'G_std_cafe', 'B_std_cafe',
                            'RGB_medio_folha', 'RGB_std_folha', 'HSV_medio_cafe', 'H_medio_cafe', 'S_medio_cafe', 'V_medio_cafe', 'HSV_std_cafe', 'H_std_cafe', 'S_std_cafe', 'V_std_cafe',
                            'HSV_medio_folha', 'HSV_std_folha', 'Agtron']

# Define cores no print
class bcolors:
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    OKGREEN = '\033[92m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'

# Função para extrair RGB e/ou Equalizar Histograma
def extrairRGB(img, equalizar=False):

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

    # Divide e extrai os canais da imagem
    R, G, B = cv2.split(img)

    return (R, G, B)

# Função para extrair HSV e/ou Equalizar Histograma
def extrairHSV(rgb_img, equalizar=False):
    # Converte imagem para HSV
    hsv_img = cv2.cvtColor(rgb_img, cv2.COLOR_BGR2HSV)

    # Divide e extrai os canais da imagem
    H, S, V = cv2.split(hsv_img)

    # Equaliza somente o canal V e retorna
    if(equalizar):
        v_equalized = cv2.equalizeHist(V)
        return (H, S, v_equalized)
    else:
        return (H, S, V)

# Funçao para aplicar quantização de cores
def quantizacaoCores(rgb_img, n_clusters=6):
    # Pega tamanho da imagem
    (h, w) = rgb_img.shape[:2]

    # converte a imagem do espaço de cores RGB para o espaço de cores L*a*b*
    # -- já que estaremos agrupando usando k-means # que é baseado na distância euclidiana, usaremos o
    # L*a* b* espaço de cor onde a distância euclidiana implica
    # significado perceptivo
    img = cv2.cvtColor(rgb_img, cv2.COLOR_BGR2LAB)

    # remodela a imagem em um vetor para que o k-means possa ser aplicado
    img = img.reshape((img.shape[0] * img.shape[1], 3))

    # Aplica o KMeans
    clt = MiniBatchKMeans(n_clusters=n_clusters, random_state=RANDOM_STATE)
    labels = clt.fit_predict(img)

    # A imagem reduzida a cores
    quant = clt.cluster_centers_.astype("uint8")[labels]

    # remodela o vetor para imagem novamente
    quant = quant.reshape((h, w, 3))

    # converte de L*a*b* para RGB
    quant = cv2.cvtColor(quant, cv2.COLOR_LAB2BGR)

    # Retorna imagem com cores reduzidas
    return quant

# Função para criar DataSet aplicando filtros
# Essa função percorre a pasta de disposivos -> condições de iluminação -> e tipo (café ou folha)
# As imagens que foram tiradas em uma mesma condição de iluminação, possuem os mesmos valores para folha
def criarDataSet(filtros):
    data = []
    # Percorre as pastas de dispositivos
    for dispositivo in DISPOSITIVOS:
        print(f"{bcolors.BOLD}{bcolors.OKGREEN}{'--------------------'}{bcolors.ENDC}\n")
        print(f"{bcolors.BOLD}{bcolors.WARNING}{dispositivo}{bcolors.ENDC}")
        # Percorre as condições de iluminação
        for condicao in LUZ:
            print(f"{bcolors.BOLD}{bcolors.BLUE}{'  '}{condicao}{bcolors.ENDC}")
            # Percorre asa opções (Café ou Folha)
            for opcao in TIPO:
                print(f"{bcolors.BOLD}{bcolors.OKGREEN}{'    '}{opcao}{bcolors.ENDC}")
                # Para cada arquivo na pasta disposivos -> condições de iluminação -> tipo faça:
                for arquivo in os.listdir(".\photos\{}\{}\{}".format(dispositivo, condicao, opcao)):
                    # Pega caminho até a imagem
                    caminho_img = os.path.join(".\photos\{}\{}\{}".format(dispositivo, condicao, opcao), arquivo)

                    # Lê a imagem
                    img = cv2.imread(caminho_img)
                    
                    if(filtros):
                        # Aplica suaviação pela mediana
                        img = cv2.medianBlur(src=img, ksize=9)

                        # Aplica o processo de quantização de cores
                        img = quantizacaoCores(img, n_clusters=6)
                    
                    # Opção folha é SEMPRE extraída primeiro.
                    # Se a opção for do tipo "FOLHA", que determina a condição de iluminação
                    # Extrair os canais RGB e HSV, calculando suas respectivas médias e desvio padrão
                    if opcao == 'Folha':
                        R_f, G_f, B_f = extrairRGB(img, equalizar=filtros)
                        media_folha_RGB = np.mean([R_f, G_f, B_f])
                        desvio_folha_RGB = np.std([R_f, G_f, B_f])

                        H_f, S_f, V_f = extrairHSV(img, equalizar=filtros)
                        media_folha_HSV = np.mean([H_f, S_f, V_f])
                        desvio_folha_HSV = np.std([H_f, S_f, V_f])

                    # Se for do tipo café
                    # Extrair os canais RGB e HSV, calculando suas respectivas médias e desvio padrão
                    else:
                        R_c, G_c, B_c = extrairRGB(img, equalizar=filtros)
                        H_c, S_c, V_c = extrairHSV(img, equalizar=filtros)

                        media_cafe_RGB = np.mean([R_c, G_c, B_c])
                        desvio_cafe_RGB = np.std([R_c, G_c, B_c])

                        media_cafe_HSV = np.mean([H_c, S_c, V_c])
                        desvio_cafe_HSV = np.std([H_c, S_c, V_c])
                        
                        # Monta uma linsta com as informações extraídas
                        geral = [media_cafe_RGB, np.mean(R_c), np.mean(G_c), np.mean(B_c), desvio_cafe_RGB, np.std(R_c), np.std(G_c), np.std(B_c), media_folha_RGB, desvio_folha_RGB, media_cafe_HSV, np.mean(H_c), np.mean(S_c), np.mean(V_c), desvio_cafe_HSV, np.std(H_c), np.std(S_c), np.std(
                            V_c), media_folha_HSV, desvio_folha_HSV]

                        # Arrendonda os valores da lista, para que tenham somente 3 casa decimais
                        geral_arredondado = [round(num, 3) for num in geral]

                        # Adiciona a lista o valor Agtron da amostra, que está no nome do arquivo
                        geral_arredondado.append('Agtron {}'.format(arquivo[0:2]))

                        # Adiciona essa linha a lista de dados
                        data.append(geral_arredondado)
            print('\n')
        print(f"{bcolors.BOLD}{bcolors.OKGREEN}{'--------------------'}{bcolors.ENDC}\n")
    return HEADER,  data

# Função para exportar arquivo CSV
def exportarCSV(header, data, name):
    with open('./data/{}.csv'.format(name), 'w', encoding='UTF8', newline='') as f:
        writer = csv.writer(f)
        # Escreve o cabeçalho (header)
        writer.writerow(header)
        # Escreve todas as linhas (data)
        writer.writerows(data)


if __name__ == '__main__':
    # Ocultando os warnings
    warnings.filterwarnings(action='ignore')

    # Roda o primeiro teste SEM filtro
    FILTRO = False
    FILE = 'all_semfiltro'
    header, data = criarDataSet(FILTRO)
    exportarCSV(header, data, FILE)

    # Roda o segundo teste COM filtro
    FILTRO = True
    FILE = 'all_comfiltro'
    header, data = criarDataSet(FILTRO)
    exportarCSV(header, data, FILE)

# Models.
from sklearn.neural_network import MLPClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.ensemble import GradientBoostingClassifier

from sklearn.neighbors import KNeighborsClassifier

# Outros classificadores
from sklearn.naive_bayes import MultinomialNB
from sklearn.naive_bayes import GaussianNB
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC, LinearSVC, NuSVC
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier, GradientBoostingClassifier

# SVC(kernel='poly', degree=8, random_state=random_state) = 56%
# GaussianNB 57.5 %
# MultinomialNB 59.4 %
# LinearSVC 42%
# NuSVC 55.2 %
# AdaBoostClassifier 29%

# Cross-Validation models.
from sklearn.model_selection import cross_validate
from sklearn.model_selection import KFold

# Metrics
from sklearn import metrics
from sklearn.model_selection import cross_val_predict

from sklearn.metrics import confusion_matrix
from sklearn.metrics import recall_score
from sklearn.metrics import precision_score
from sklearn.metrics import accuracy_score
from sklearn.metrics import f1_score
from sklearn.metrics import classification_report

# Plot Matrix
import seaborn as sn
import matplotlib.pyplot as plt

import pandas as pd
import numpy as np

# Encoders
from sklearn.preprocessing import LabelEncoder
from sklearn.preprocessing import LabelBinarizer
from sklearn.preprocessing import StandardScaler

# Tempo de execução
import time

random_state = 42
FILE = 'all_comfiltro'
EXPORT_NAME = './classifiers/classifier_{}.sav'.format(FILE)


def ApplyesKFold(x_axis, y_axis):
    # KFold settings.
    # shuffle=True, Shuffle (embaralhar) the data.
    kfold = KFold(n_splits=5, shuffle=False)

    # Axis
    x = x_axis
    y = y_axis

    # Models instances.

    # Floresta Aleatória
    randomForest = RandomForestClassifier(
        n_estimators=500, max_features="auto", random_state=random_state, class_weight="balanced_subsample")

    # Perceptron Multicamadas
    mplc = MLPClassifier(max_iter=25000, activation='identity',
                         solver='lbfgs', hidden_layer_sizes=(9,2), random_state=random_state)

    # KNeighborsClassifier
    # mnb = KNeighborsClassifier(n_neighbors=10)
    mnb = MultinomialNB()

    # Applyes KFold to models.
    inicio = time.time()
    randomForest_result_pred = cross_val_predict(randomForest, x, y, cv=kfold)
    fim = time.time()
    time_random = np.round(fim - inicio, 4)

    inicio = time.time()
    mplc_result_pred = cross_val_predict(mplc, x, y, cv=kfold)
    fim = time.time()
    time_mplc = np.round(fim - inicio, 4)

    inicio = time.time()
    mnb_result_pred = cross_val_predict(mnb, x, y, cv=kfold)
    fim = time.time()
    time_mnb = np.round(fim - inicio, 4)

    # Get precision scores.
    randomForest_f1 = f1_score(
        y, randomForest_result_pred, average='weighted')
    randomForest_precision = precision_score(
        y, randomForest_result_pred, average='weighted')
    randomForest_recall = recall_score(
        y, randomForest_result_pred, average='weighted')

    mplc_f1 = f1_score(
        y, mplc_result_pred, average='weighted')
    mplc_precision = precision_score(
        y, mplc_result_pred, average='weighted')
    mplc_recall = recall_score(
        y, mplc_result_pred, average='weighted')

    mnb_f1 = f1_score(
        y, mnb_result_pred, average='weighted')
    mnb_precision = precision_score(
        y, mnb_result_pred, average='weighted')
    mnb_recall = recall_score(
        y, mnb_result_pred, average='weighted')

    titulo = 'HSV'
    print_confusion_matrix('mnb', y, mnb_result_pred, titulo)
    print_confusion_matrix('randomForest', y, randomForest_result_pred, titulo)
    print_confusion_matrix('mplc', y, mplc_result_pred, titulo)
    print_confusion_matrix('mnb', y, mnb_result_pred, titulo)

    # Creates a dictionary to store Linear Models.
    dic_random = {
        "Classe": "Random Forest",
        "F1": '{} %'.format(np.round(np.mean(randomForest_f1) * 100, 1)),
        "Precisão": '{} %'.format(np.round(np.mean(randomForest_precision) * 100, 1)),
        "Recall": '{} %'.format(np.round(np.mean(randomForest_recall) * 100, 1)),
        "time": '{} s'.format(time_random), }

    dic_mplc = {
        "Classe": "Multi-layer Perceptron",
        "F1": '{} %'.format(np.round(np.mean(mplc_f1) * 100, 1)),
        "Precisão": '{} %'.format(np.round(np.mean(mplc_precision) * 100, 1)),
        "Recall": '{} %'.format(np.round(np.mean(mplc_recall) * 100, 1)),
        "time": '{} s'.format(time_mplc, 4), }

    dic_mnb = {
        "Classe": "Naive Bayes",
        "F1": '{} %'.format(np.round(np.mean(mnb_f1) * 100, 1)),
        "Precisão": '{} %'.format(np.round(np.mean(mnb_precision) * 100, 1)),
        "Recall": '{} %'.format(np.round(np.mean(mnb_recall) * 100, 1)),
        "time": '{} s'.format(time_mnb, 4), }

    print(f"{bcolors.BOLD}{bcolors.OKGREEN}{'----------'}{bcolors.ENDC}\n")
    print(f"{bcolors.BOLD}{bcolors.OKGREEN}{dic_random}{bcolors.ENDC}\n")
    print(f"{bcolors.BOLD}{bcolors.OKGREEN}{'----------'}{bcolors.ENDC}\n")
    print(f"{bcolors.BOLD}{bcolors.OKGREEN}{dic_mplc}{bcolors.ENDC}\n")
    print(f"{bcolors.BOLD}{bcolors.OKGREEN}{'----------'}{bcolors.ENDC}\n")
    print(f"{bcolors.BOLD}{bcolors.OKGREEN}{dic_mnb}{bcolors.ENDC}\n")
    print(f"{bcolors.BOLD}{bcolors.OKGREEN}{'----------'}{bcolors.ENDC}\n")


def print_confusion_matrix(nome, y, y_pred, titulo):

    cm = confusion_matrix(y, y_pred)

    plt.figure(figsize=(10, 7))
    ax = plt.subplot()

    df_cm = pd.DataFrame(cm, index=[25, 35, 45, 55, 65, 75], columns=[
                         25, 35, 45, 55, 65, 75])

    sn.set(font_scale=1.4)
    sn.heatmap(df_cm, annot=True, ax=ax, annot_kws={"size": 16}, cmap='Greens')
    
    ax.set_title(titulo)
    ax.set_xlabel('Valor Previsto')
    ax.set_ylabel('Valor Verdadeiro')

    plt.savefig("{}.pdf".format(nome), bbox_inches='tight')

    print('\n')


def fix_dataset(hsv):
    # Pegando a base e dividindo em treino e teste
    dataframe = pd.read_csv('./data/{}.csv'.format(FILE))  # , delimiter = ';')

    # Remove Agtron #95
    dataframe = dataframe[dataframe.Agtron != 'Agtron 95']

    # Remove Agtron #85
    dataframe = dataframe[dataframe.Agtron != 'Agtron 85']

    # ## RGB
    # dataframe = dataframe.drop(
    #     dataframe.columns[[10, 11, 12, 13,  14, 15, 16, 17, 18,  19]], axis=1)

    ## HSV
    dataframe = dataframe.drop(
            dataframe.columns[[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]], axis=1)

    print(dataframe.head(2))
    print(dataframe.columns)
    print('Data possui {} colunas'.format(len(dataframe.columns)))
    return dataframe


def get_data_labels(hsv):

    dataframe = fix_dataset(hsv)
    array = dataframe.values

    data = array[:, 0:(len(dataframe.columns)-1)]
    labels = array[:, (len(dataframe.columns)-1)]

    print("Quantidade de atributos: {}".format(len(data[0])))
    print("Labels: {}".format(set(labels)))

    return data, labels


class bcolors:
    OKGREEN = '\033[92m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'


if __name__ == '__main__':
    rslt = []

    # x, y = get_data_labels(False)
    # rslt.append(ApplyesKFold(x, y, False))

    x, y = get_data_labels(True)
    ApplyesKFold(x, y)
    # rslt.append()

    # print('\n\n')
    # for rs in rslt:
    #     print(f"{bcolors.BOLD}{bcolors.OKGREEN}{rs}{bcolors.ENDC}\n")

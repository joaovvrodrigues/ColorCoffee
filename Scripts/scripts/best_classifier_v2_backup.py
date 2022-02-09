# Models.
from sklearn.neural_network import MLPClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.ensemble import GradientBoostingClassifier

from sklearn.neighbors import KNeighborsClassifier

# Cross-Validation models.
from sklearn.model_selection import cross_validate
from sklearn.model_selection import KFold

# Metrics
from sklearn import metrics
from sklearn.model_selection import cross_val_predict
from sklearn.metrics import confusion_matrix
from sklearn.metrics import precision_score

# Plot Matrix
import seaborn as sn
import matplotlib.pyplot as plt

import pandas as pd
import numpy as np

from numpy import array

from sklearn.model_selection import cross_val_score
from sklearn.preprocessing import LabelBinarizer

random_state = 42
FILE = 'coffee_data'
EXPORT_NAME = './classifiers/classifier_{}.sav'.format(FILE)


def ApplyesKFold(x_axis, y_axis, hsv, binary):
    # KFold settings.
    # shuffle=True, Shuffle (embaralhar) the data.
    kfold = KFold(n_splits=5, shuffle=False)

    # Axis
    x = x_axis
    y = y_axis

    # Models instances.

    # Floresta Aleatória
    randomForest = RandomForestClassifier(
        n_estimators=100, max_features="auto", random_state=random_state, class_weight="balanced_subsample")

    # Perceptron Multicamadas
    mplc = MLPClassifier(max_iter=15000, activation='identity', hidden_layer_sizes=(
        1,), solver='lbfgs', random_state=random_state)

    # KNeighborsClassifier
    knn = KNeighborsClassifier(n_neighbors=10)
    
    y_n_binary  = y
    
    if binary:
        # BINARIZANDO LABELS
        lb = LabelBinarizer()
        y = lb.fit_transform(y)
        y = array(y)

    #   if binary:
    #     # ENCODER LABELS
    #     le = preprocessing.LabelEncoder()
    #     le.fit(y)
    #     print(list(le.classes_))
    #     y = le.transform(y)


    # Applyes KFold to models.
    randomForest_result = cross_val_score(
        randomForest, x, y, cv=kfold, scoring='precision_micro')
    mplc_result = cross_val_score(
        mplc, x, y, cv=kfold, scoring='precision_micro')
    knn_result = cross_val_score(
        knn, x, y, cv=kfold, scoring='precision_micro')

    print_confusion_matrix('randomForest', randomForest,
                           x, y, kfold, hsv, binary)
    print_confusion_matrix('mplc', mplc, x, y, kfold, hsv, binary)
    print_confusion_matrix('knn', knn, x, y, kfold, hsv, binary)

    # Creates a dictionary to store Linear Models.
    dic_models = {
        "hsv": hsv,
        "binary": binary,
        "randomForest": np.round(np.mean(randomForest_result), 2),
        "mplc": np.round(np.mean(mplc_result), 2),
        "knn": np.round(np.mean(knn_result), 2),
    }

    return dic_models

def print_confusion_matrix(nome, clf, x, y, kfold, hsv, binary,):
    y_pred = cross_val_predict(clf, x, y, cv=kfold)
    print(precision_score(y, y_pred, average='micro'))
    # y_n_b = []
    # y_n_b_pred = []

    # for i in range(len(y)):
    #     y_n_b.append('Agtron 25')
    #     y_n_b_pred.append('Agtron 25')

    # if binary:
    #     options = ['Agtron 25', 'Agtron 35', 'Agtron 45', 'Agtron 55', 'Agtron 65', 'Agtron 75']
    #     for opt in options:
    #         convertido = y[np.where(y_n_binary == opt)]
    #         # print(np.where(y_n_binary == opt))

    #         convertido_pred = y_pred[np.where(y_n_binary == opt)]
            
    #         for i in range(len(y)):
    #             a = convertido == y[i]
    #             if a.all():
    #                 y_n_b[i] = opt
    #             b = y_pred[i] == convertido[0]
    #             if b.all():
    #                 y_n_b_pred[i] = opt
    
    # print(y_pred)
    # print("y_n_b_pred: {}".format(set(y_n_b_pred)))

    # lables = [25, 35, 45, 55, 65, 75]
    # if binary:
    #     cm = confusion_matrix(y_n_b, y_n_b_pred)
    # else:
    #     cm = confusion_matrix(y, y_pred)
        
    # # mcm = metrics.multilabel_confusion_matrix(y, y_pred, labels=[
    # #                                           'Agtron 25', 'Agtron 35', 'Agtron 45', 'Agtron 55', 'Agtron 65', 'Agtron 75'])

    # # TN = mcm[:, 0, 0]
    # # TP = mcm[:, 1, 1]
    # # FN = mcm[:, 1, 0]
    # # FP = mcm[:, 0, 1]

    # # print('True positive = ', TP)
    # # print('False positive = ', len(FP))
    # # print('False negative = ', len(FN))
    # # print('True negative = ', TN)

    # # print('\nAccuracy: {}'.format(
    # #     (sum(TP)+sum(TN))/(sum(TP)+sum(TN)+sum(FP)+sum(FN))))
    # # print('Precision: {}'.format(sum(TP)/(sum(TP)+sum(FP))))
    # # print('Recall: {}'.format(sum(TP)/(sum(TP)+sum(FN))))
    # # print(metrics.classification_report(y, y_pred))

    # plt.figure(figsize=(10, 7))
    # ax = plt.subplot()

    # # df_cm = pd.DataFrame(cm, index=[25, 35, 45, 55, 65, 75], columns=[
    # #                      25, 35, 45, 55, 65, 75])

    # sn.set(font_scale=1.4)
    # sn.heatmap(cm, annot=True, ax=ax, annot_kws={"size": 16}, cmap='Greens')

    # # sn.heatmap(df_cm, annot=True, annot_kws={"size": 16}, cmap='Greens')

    # ax.set_xlabel('Predicted labels')
    # ax.set_ylabel('True labels')
    # ax.xaxis.set_ticklabels(lables)
    # ax.yaxis.set_ticklabels(lables)

    # if hsv:
    #     if binary:
    #         plt.savefig("{}_matrix_HSV_Binary.pdf".format(
    #             nome), bbox_inches='tight')
    #     else:
    #         plt.savefig("{}_matrix_HSV.pdf".format(nome), bbox_inches='tight')
    # else:
    #     if binary:
    #         plt.savefig("{}_matrix_RGB_Binary.pdf".format(
    #             nome), bbox_inches='tight')
    #     else:
    #         plt.savefig("{}_matrix_RGB.pdf".format(nome), bbox_inches='tight')

    print('\n')
    print('\n')


def fix_dataset(hsv):
    # Pegando a base e dividindo em treino e teste
    dataframe = pd.read_csv('./data/{}.csv'.format(FILE))

    # Remove Agtron #95
    dataframe = dataframe[dataframe.Agtron_value != 'Agtron 95']

    # Remove Agtron #85
    dataframe = dataframe[dataframe.Agtron_value != 'Agtron 85']

    # Remove colunas não utilizadas
    dataframe = dataframe.drop(
        dataframe.columns[[0, 1, 2, 3, 4,  5, 19, 20]], axis=1)

    if(hsv):
        # Remove RGB
        dataframe = dataframe.drop(
            dataframe.columns[[0, 1, 2, 3, 4, 5]], axis=1)
    else:
        # Remove HSV
        dataframe = dataframe.drop(
            dataframe.columns[[6, 7, 8, 9, 10, 11]], axis=1)

    print(dataframe.head(2))
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
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


if __name__ == '__main__':
    rslt = []
    hsv = False
    binary = False

    x, y = get_data_labels(hsv)
    rslt.append(ApplyesKFold(x, y, hsv, binary))

    hsv = True
    binary = False

    x, y = get_data_labels(hsv)
    rslt.append(ApplyesKFold(x, y, hsv, binary))

    hsv = False
    binary = True

    x, y = get_data_labels(hsv)
    rslt.append(ApplyesKFold(x, y, hsv, binary))

    hsv = True
    binary = True

    x, y = get_data_labels(hsv)
    rslt.append(ApplyesKFold(x, y, hsv, binary))

    for rs in rslt:
        print(f"{bcolors.OKBLUE}{rs}{bcolors.ENDC}\n")

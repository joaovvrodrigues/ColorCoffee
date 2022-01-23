import sklearn
import pandas as pd
import numpy as np
import joblib

from sklearn import metrics
from sklearn import model_selection

from sklearn.neural_network import MLPClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.ensemble import GradientBoostingClassifier

from sklearn.model_selection import cross_validate
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import KFold
from sklearn.model_selection import GridSearchCV

random_state = 42
HSV = False
FILE = 'coffee_data'
EXPORT_NAME = './classifiers/classifier_{}.sav'.format(FILE)


def fix_dataset():
    # Pegando a base e dividindo em treino e teste
    dataframe = pd.read_csv('./data/{}.csv'.format(FILE))

    # Remove Dispositivo
    # dataframe = dataframe[dataframe.Device != 'Lumix']

    # Remove Agtron #95
    dataframe = dataframe[dataframe.Agtron_value != 95]

    # Remove Agtron #85
    dataframe = dataframe[dataframe.Agtron_value != 85]

    # Remove colunas não utilizadas
    dataframe = dataframe.drop(
        dataframe.columns[[0, 1, 2, 3, 4,  5, 19, 20]], axis=1)

    # Remove RGB
    # dataframe = dataframe.drop(
    #     dataframe.columns[[0, 1, 2, 3, 4, 5, 9]], axis=1)

    # Remove HSV
    dataframe = dataframe.drop(dataframe.columns[[6, 7, 8, 9, 10, 11]], axis=1)

    # Café em RGB, papel em HSV
    # dataframe = dataframe.drop(dataframe.columns[[6, 7, 8, 3, 4, 5]], axis=1)

    print(dataframe.head())
    return dataframe


def get_data_labels():
    lab = False
    gray = False

    if(not lab and not gray):
        dataframe = fix_dataset()

        array = dataframe.values

        data = array[:, 0:(len(dataframe.columns)-1)]
        labels = array[:, (len(dataframe.columns)-1)]
    else:
        if(gray):
            dataframe = fix_dataset_Gray()
            array = dataframe.values

            data = array[:, 1:(len(dataframe.columns))]
            labels = array[:, 0]

        else:
            dataframe = fix_dataset_LAB()

            array = dataframe.values

            data = array[:, 1:(len(dataframe.columns))]
            labels = array[:, 0]

    print("Quantidade de atributos: {}".format(len(data[0])))
    print("Labels: {}".format(set(labels)))

    return data, labels


def train_test_split(data, labels):
    train, test, train_labels, test_labels = model_selection.train_test_split(
        data, labels, test_size=0.2, random_state=random_state)

    return train, test, train_labels, test_labels


def classification():
    # Realizando a classificação com a base de treino e retornando modelo

    # Floresta Aleatória
    # model = RandomForestClassifier(
    #     n_estimators=100, max_features=None, random_state=random_state)

    # Perceptron Multicamadas
    # model = MLPClassifier(max_iter=5000, activation='identity', hidden_layer_sizes=(
    # 1,), solver='lbfgs', random_state=random_state)

    # GradientBoostingClassifier
    model = GradientBoostingClassifier(
    n_estimators=20, learning_rate=0.5, max_features=2, max_depth=2, random_state=random_state)

    return model


def export_model(model):
    # Exporta o modelo em formato de arquivo
    joblib.dump(model, EXPORT_NAME)


def import_test_model(test, test_labels):
    # Importa o modelo e testa com a base de teste (Provando que é o mesmo modelo)
    loaded_model = joblib.load(EXPORT_NAME)
    result = loaded_model.score(test, test_labels)
    print(result)

    return loaded_model


def classifier_new_data(model):
    # Pegando modelo importante e dando predict em uma nova entrada
    pred = model.predict([[184, 170, 151]])
    print(pred)


def find_best_parameters():
    # Função para encontrrar os melhores parametros para a rede neural
    train, test, train_labels, test_labels = train_test_split()
    param_grid = [
        {
            'activation': ['identity', 'logistic', 'tanh', 'relu'],
            'solver': ['lbfgs', 'sgd', 'adam'],
            'hidden_layer_sizes': [
                (1,), (2,), (3,), (4,), (5,), (6,), (7,), (8,), (9,), (10,), (11,
                                                                              ), (12,), (13,), (14,), (15,), (16,), (17,), (18,), (19,), (20,), (21,)
            ]
        }
    ]
    clf = GridSearchCV(MLPClassifier(), param_grid, cv=3, scoring='accuracy')
    clf.fit(train, train_labels)

    print("Best parameters set found on development set:")
    print(clf.best_params_)


def main():
    print('\n===========================\n')

    data, labels = get_data_labels()

    # Pegando o modelo de classificação
    model = classification()

    kfold = KFold(n_splits=5, shuffle=False)

    nome_metricas = ['accuracy'] #, 'precision_macro', 'recall_macro']
    metricas = cross_validate(model, data, labels, cv=5, scoring=nome_metricas)
    print(np.round(np.mean(metricas['test_accuracy']),2))
    # for met in metricas:
    #     print(f"- {met}:")
    #     # print(f"-- {metricas[met]}")
    #     print(f"-- {np.round(np.mean(metricas[met]),2)} +- {np.round(np.std(metricas[met]),2)}\n")
    
    # result = cross_val_score(model, data, labels, cv=kfold, scoring=['accuracy'])
    # print("acuracias:", acuracias)
   
    # print(result)
    # print(
    #     "Mean R^2 for Cross-Validation K-Fold: {0}".format(np.round(result.mean(), 2)))

    # # Divindo em treino e teste
    # train, test, train_labels, test_labels = train_test_split(data, labels)

    # # Pegando o modelo de classificação
    # model = classification()

    # # Treinando o modelo
    # trained = model.fit(train, train_labels)

    # # Realizando predição
    # predicted = model.predict(test)

    # # Obtendo a acurácia do modelo
    # ac = metrics.accuracy_score(predicted, test_labels)

    # # Obtendo matriz de confusão
    # mcm = metrics.multilabel_confusion_matrix(test_labels, predicted, labels=[
    #                                           25, 35, 45, 55, 65, 75, 85, 95])

    # tn = mcm[:, 0, 0]
    # tp = mcm[:, 1, 1]
    # fn = mcm[:, 1, 0]
    # fp = mcm[:, 0, 1]

    # # Verificando se algum item não foi rotulado
    # naoRotulados = set(test_labels) - set(predicted)

    # if len(naoRotulados) != 0:
    #     print('\n===========================\n')
    #     print(
    #         'Alguns rótulos em test_labels não aparecem no predicted [set() == vazio]')
    #     print(naoRotulados)

    # print('\n===========================\n')
    # # fp, fn, tp, tn
    # print("FP: {}, FN: {}, TP: {}, TN: {}".format(fp, fn, tp, tn))

    # print('\n===========================\n')

    # # Mostrando métricas
    # print(metrics.classification_report(test_labels, predicted))

    # print('\n===========================\n')

    # nome_metricas = ['accuracy', 'precision_macro', 'recall_macro']
    # metricas = cross_validate(model, data, labels, cv=10, scoring=nome_metricas)
    # for met in metricas:
    #     print(f"- {met}:")
    #     # print(f"-- {metricas[met]}")
    #     print(f"-- {np.round(np.mean(metricas[met]),2)} +- {np.round(np.std(metricas[met]),2)}\n")

    # export_model(model)

    # model = import_test_model(test, test_labels)
    # classifier_new_data(model)


main()


# def fix_dataset_Gray():
#     # Pegando a base e dividindo em treino e teste
#     dataframe = pd.read_csv('./data/{}.csv'.format(FILE))

#     # Remove Agtron #95
#     dataframe = dataframe[dataframe.Agtron_value != 95]

#     # Remove Agtron #85
#     dataframe = dataframe[dataframe.Agtron_value != 85]

#     # Remove Agtron #25
#     # dataframe = dataframe[dataframe.Agtron_value != 25]

#     # Remove colunas não utilizadas
#     dataframe = dataframe.drop(
#         dataframe.columns[[0, 1, 2, 3, 4,  5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 19, 20]], axis=1)

#     # ============ CONJUNTO SEM PAPEL ============
#     # Remove papel
#     dataframe = dataframe.drop(dataframe.columns[[1, 2, 3, 4, 5, 6]], axis=1)
#     dataframe = dataframe.drop(dataframe.columns[[2]], axis=1)

#     # ============ CONJUNTO SEM PAPEL ============

#     print(dataframe.head())
#     return dataframe


# def fix_dataset_LAB():
#     # Pegando a base e dividindo em treino e teste
#     dataframe = pd.read_csv('./data/{}.csv'.format(FILE))

#     # Remove Agtron #95
#     dataframe = dataframe[dataframe.Agtron_value != 95]

#     # Remove Agtron #85
#     dataframe = dataframe[dataframe.Agtron_value != 85]

#     # Remove Agtron #25
#     # dataframe = dataframe[dataframe.Agtron_value != 25]

#     # Remove colunas não utilizadas
#     dataframe = dataframe.drop(
#         dataframe.columns[[0, 1, 2, 3, 4,  5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 19, 20]], axis=1)

#     # ============ CONJUNTO SEM PAPEL ============
#     # Remove papel
#     dataframe = dataframe.drop(dataframe.columns[[4, 5, 6]], axis=1)

#     # ============ CONJUNTO SEM PAPEL ============

#     print(dataframe.head())
#     return dataframe

import sklearn
import pandas as pd
# import numpy as np
import joblib

from sklearn import metrics
from sklearn import model_selection

from sklearn.neural_network import MLPClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.svm import LinearSVC
from sklearn.linear_model import LogisticRegression

from sklearn import svm

from sklearn.model_selection import GridSearchCV


HSV = False
FILE = 'coffe_hsv'
EXPORT_NAME = './classifiers/classifier_{}.sav'.format(FILE)


def train_test_split():
    # Pegando a base e dividindo em treino e teste
    dataframe = pd.read_csv('./data/{}.csv'.format(FILE))
    array = dataframe.values

    data = array[:, 0:5]
    labels = array[:, 5]
    test_size = 0.33

    # print(data)
    # print(labels)

    seed = 7
    train, test, train_labels, test_labels = model_selection.train_test_split(
        data, labels, test_size=test_size, random_state=seed)
    return train, test, train_labels, test_labels


def classification():
    # Realizando a classificação com a base de treino e retornando modelo

    # Perceptron Multicamadas
    # {'activation': 'relu', 'hidden_layer_sizes': (13,), 'solver': 'lbfgs'}
    # model = MLPClassifier(max_iter=2000, activation='identity', hidden_layer_sizes=(1,), solver='lbfgs', random_state=120)

    # Floresta Aleatória
    # model = RandomForestClassifier(n_estimators=100, max_features=None)

    # model.fit(train, train_labels)
    # print("Score de modelo: {}".format(model.score(test, test_labels)))

    # Arvore de Descisão
    # model = DecisionTreeClassifier(random_state=12)

    # LinearSVC 37%
    # model = LinearSVC(C=1.0, class_weight=None, dual=True, fit_intercept=True,
    #  intercept_scaling=1, loss='squared_hinge', max_iter=1000,
    #  multi_class='ovr', penalty='l2', random_state=None, tol=0.0001,
    #  verbose=0)

    # LogisticRegression 42%
    # model = LogisticRegression()

    model = svm.SVC()


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

    # Divindo em treino e teste
    train, test, train_labels, test_labels = train_test_split()

    # Pegando o modelo de classificação
    model = classification()

    # Treinando o modelo
    trained = model.fit(train, train_labels)

    # Realizando predição
    predicted = model.predict(test)

    # Obtendo a acurácia do modelo
    ac = metrics.accuracy_score(predicted, test_labels)

    # Obtendo matriz de confusão
    mcm = metrics.multilabel_confusion_matrix(test_labels, predicted, labels=[
                                              25, 35, 45, 55, 65, 75, 85, 95])

    tn = mcm[:, 0, 0]
    tp = mcm[:, 1, 1]
    fn = mcm[:, 1, 0]
    fp = mcm[:, 0, 1]

    # Verificando se algum item não foi rotulado
    naoRotulados = set(test_labels) - set(predicted)

    if len(naoRotulados) != 0:
        print('\n===========================\n')
        print(
            'Alguns rótulos em test_labels não aparecem no predicted [set() == vazio]')
        print(naoRotulados)

    print('\n===========================\n')
    # fp, fn, tp, tn
    print("FP: {}, FN: {}, TP: {}, TN: {}".format(fp, fn, tp, tn))

    print('\n===========================\n')

    # Mostrando métricas
    print(metrics.classification_report(test_labels, predicted))

    print('\n===========================\n')

    # export_model(model)

    # model = import_test_model(test, test_labels)
    # classifier_new_data(model)


main()

import sklearn
import pandas as pd
# import numpy as np
import joblib

from sklearn import metrics
from sklearn import model_selection
from sklearn.neural_network import MLPClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.tree import DecisionTreeClassifier

from sklearn.model_selection import GridSearchCV


HSV = False
FILE = 'coffe_hsv'
EXPORT_NAME = './classifiers/classifier_{}.sav'.format(FILE)


def train_test_split():
    # Pegando a base e dividindo em treino e teste
    dataframe = pd.read_csv('./data/{}.csv'.format(FILE))
    array = dataframe.values
    array = array.sample(1)

    X = array[:, 0:3]
    Y = array[:, 3]
    test_size = 0.33

    seed = 7
    X_train, X_test, Y_train, Y_test = model_selection.train_test_split(
        X, Y, test_size=test_size, random_state=seed)
    return X_train, X_test, Y_train, Y_test


def classification(X_train, X_test, Y_train, Y_test):
    # Realizando a classificação com a base de treino e retornando modelo

    # Perceptron Multicamadas
    # max_iter=2000, hidden_layer_sizes=200, solver = 'lbfgs')
    # model = MLPClassifier(max_iter=2000, activation='relu', hidden_layer_sizes=(
    #     16,), solver='lbfgs', random_state=120)  # 60% de acerto

    # Floresta Aleatória
    model = RandomForestClassifier(n_estimators=100, max_features=None)

    model.fit(X_train, Y_train)
    print(model.score(X_test, Y_test))

    return model


def export_model(model):
    # Exporta o modelo em formato de arquivo
    joblib.dump(model, EXPORT_NAME)


def import_test_model(X_test, Y_test):
    # Importa o modelo e testa com a base de teste (Provando que é o mesmo modelo)
    loaded_model = joblib.load(EXPORT_NAME)
    result = loaded_model.score(X_test, Y_test)
    print(result)

    return loaded_model


def classifier_new_data(model):
    # Pegando modelo importante e dando predict em uma nova entrada
    pred = model.predict([[184, 170, 151]])
    print(pred)


def find_best_parameters():
    # Função para encontrrar os melhores parametros para a rede neural
    X_train, X_test, Y_train, Y_test = train_test_split()
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
    clf.fit(X_train, Y_train)

    print("Best parameters set found on development set:")
    print(clf.best_params_)


def main():
    print('\n===========================\n')

    X_train, X_test, Y_train, Y_test = train_test_split()
    model = classification(X_train, X_test, Y_train, Y_test)

    trained = model.fit(X_train, Y_train)

    # I make the predictions
    predicted = model.predict(X_test)

    # I obtain the accuracy of this fold
    ac = metrics.accuracy_score(predicted, Y_test)

    # I obtain the confusion matrix
    mcm = metrics.multilabel_confusion_matrix(Y_test, predicted, labels=[
                                              '25', '35', '45', '55', '65', '75', '85', '95'])

    tn = mcm[:, 0, 0]
    tp = mcm[:, 1, 1]
    fn = mcm[:, 1, 0]
    fp = mcm[:, 0, 1]

    print('\n===========================\n')

    print('some labels in y_test dont appear in predicted')
    a = set(Y_test) - set(predicted)
    print(a)

    print('\n===========================\n')

    print(fp, fn, tp, tn)

    print('\n===========================\n')

    print(metrics.classification_report(Y_test, predicted))

    print('\n===========================\n')

    # export_model(model)

    # model = import_test_model(X_test, Y_test)
    # classifier_new_data(model)


main()

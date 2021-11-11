import sklearn
import pandas as pd
import joblib

from sklearn import model_selection
from sklearn import neural_network
from sklearn.ensemble import RandomForestClassifier
from sklearn.tree import DecisionTreeClassifier

HSV = False
FILE = 'coffe_mean_rgb'
EXPORT_NAME = 'classifier_{}.sav'.format(FILE)


def train_test_split():
    # Pegando a base e dividindo em treino e teste
    dataframe = pd.read_csv('./data/{}.csv'.format(FILE))
    array = dataframe.values

    X = array[:, 0:3]
    Y = array[:, 3]
    test_size = 0.33

    seed = 7
    X_train, X_test, Y_train, Y_test = model_selection.train_test_split(
        X, Y, test_size=test_size, random_state=seed)
    return X_train, X_test, Y_train, Y_test


def classification(X_train, X_test, Y_train, Y_test):
    # Realizando a classificação com a base de treino e retornando modelo
    model = RandomForestClassifier()
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


def main():
    X_train, X_test, Y_train, Y_test = train_test_split()
    model = classification(X_train, X_test, Y_train, Y_test)
    export_model(model)

    model = import_test_model(X_test, Y_test)
    classifier_new_data(model)


main()

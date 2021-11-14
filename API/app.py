from flask import Flask, request, jsonify
import os
import random
import sklearn
import joblib
from os.path import join, dirname, realpath


FILE = 'coffe_mean_rgb'
EXPORT_NAME = join(dirname(realpath(__file__)),
                   'static/classifier_{}.sav'.format(FILE))


def import_test_model():
    loaded_model = joblib.load(EXPORT_NAME)
    return loaded_model


def classifier_new_data(model, rgb):
    pred = model.predict([rgb])
    return pred


app = Flask(__name__)


@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"


@app.route('/random', methods=['GET'])
def randomColor():
    return jsonify({
        "color": "color",
        "prediction": "Agtron {}".format(random.randint(0, 100)),
        "confidence": "{}".format(random.randint(0, 100)),
        "rgb": [random.randint(0, 255), random.randint(0, 255), random.randint(0, 255)]
    }), 200


@app.route('/analisys', methods=['POST'])
def analisys():
    if request.method == 'POST':

        r = int(request.json['r'])
        g = int(request.json['g'])
        b = int(request.json['b'])

        h = request.json['h']
        s = request.json['s']
        v = request.json['v']

        model = import_test_model()
        prediction = classifier_new_data(model, [r, g, b])

        return jsonify({
            "color": "color",
            "prediction": prediction[0],
            "confidence": "96",
            "rgb": [r, b, g]
        }), 200


if __name__ == "__main__":
    # app.run(debug=True, host='0.0.0.0', port=33) # Dev
    app.run(threaded=True, port=5000) # Produção

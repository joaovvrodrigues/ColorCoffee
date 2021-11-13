from flask import Flask, request, jsonify
import os
# from datetime import datetime
import random

app = Flask(__name__)


@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"


@app.route('/random', methods=['GET'])
def randomColor():
    return jsonify({
        "color": "color",
        "prediction": "{}".format(random.randint(0, 100)),
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

        print(h, s, v)

        return jsonify({
            "color": "color",
            "prediction": "55",
            "confidence": "96",
            "rgb": [r, b, g]
        }), 200


if __name__ == "__main__":
    # port = int(os.environ.get("PORT", 5000))
    # app.run(threaded=True, host='0.0.0.0', port=port)
    app.run(threaded=True, port=5000)

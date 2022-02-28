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
    return """
<p>
Eu quero problemas fúteis, preocupações inúteis <br>
Só Deus sabe o quanto eu lutei, vendo o mundo dizer: Não tem <br>
(Hum, bem, é passado, passado) <br> <br>
Bom, hoje eles diz: Cê tem o dom (Obrigado, obrigado) <br>
Fui quem obedece, agora eu sou quem manda <br>
Vou ver o que acontece, mas lá da varanda <br>
É tipo um trampo social, sério  <br> <br>
Tô dando a chance de ver como nasce um império <br>
Com o brilho dos diamante que eles tanto diz <br>
Multiplicado 10 mil vez no olhar feliz das minhas menina <br> 
Sente o clima, eu posso comprar Hennessy, mas prefiro tubaína <br> <br>
Aos que apontam, eu trago a resposta mais louca <br>
Não diz que eu sou marrento não <br>
Trampa mais e melhor que eu, cala a boca <br> <br>
Xô devolver o orgulho do gueto <br>
E dar outro sentido pra frase: Tinha que ser preto <br>

<br><br><br> Emicida
</p>    
        """


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
    app.run(debug=True, host='0.0.0.0', port=33) # Dev
    # app.run(threaded=True, port=5000)  # Produção

from flask import Flask, Blueprint, request, render_template, jsonify
import os
from datetime import datetime
import random


mod = Blueprint('api', __name__, template_folder='template',
                static_folder='./static')


UPLOAD_URL = 'http://192.168.1.29:33/images/'


@mod.route('/', methods=['GET'])
def home():
    return render_template('index.html')


@mod.route('/random', methods=['GET'])
def randomColor():
    return jsonify({
        "color": "color",
        "prediction": "{}".format(random.randint(0, 100)),
        "confidence": "{}".format(random.randint(0, 100)),
        "rgb": [random.randint(0, 255), random.randint(0, 255), random.randint(0, 255)]
    }), 200


@mod.route('/analisys', methods=['POST'])
def analisys():
    if request.method == 'POST':

        r = int(request.json['r'])
        g = int(request.json['g'])
        b = int(request.json['b'])

        h = request.json['h']
        s = request.json['s']
        v = request.json['v']
        
        print(h,s,v)

        return jsonify({
            "color": "color",
            "prediction": "55",
            "confidence": "96",
            "rgb": [r, b, g]
        }), 200


@mod.route('/send', methods=['POST'])
def send():
    if request.method == 'POST':
        # Se imagem não for encontrada
        if 'file' not in request.files:
            return "File not found", 400

        # Se nome igual a vazio
        image = request.files['file']
        if image.filename == '':
            return "File name not found", 403

        else:
            # Salvando imagem em disco
            path = os.path.join(
                os.getcwd()+'\\modules\\images\\'+image.filename)
            image.save(path)
            
            return jsonify({
                "color": "color",
                "prediction": "55",
                "confidence": "96",
                "rgb": [random.randint(0, 255), random.randint(0, 255), random.randint(0, 255)]
            }), 200

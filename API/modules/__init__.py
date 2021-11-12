from flask import Flask

app = Flask(__name__)

#TODO: Change to False
app.config["DEBUG"] = False

from modules.api.routes import mod

app.register_blueprint(api.routes.mod, url_prefix='/api')
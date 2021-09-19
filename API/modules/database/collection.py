# TODO: Ativar se necessário

from pymongo import MongoClient
from bson import ObjectId

client = MongoClient("mongodb://localhost:27017")

db = client.koffee
image_details = db.imageData
#(i_name, prediction, conf, time, url):
def addNewImage(i_name, time, url):
    image_details.insert({
        "file_name": i_name,
        # "prediction": prediction,
        # "confidence": conf,
        "upload_time": time,
        "url": url
    })

# TODO: Reativar se necessário.
# def getAllImages():
#     data = image_details.find()
#     return data

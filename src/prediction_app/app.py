import os
import falcon
from keras.models import load_model
from .predict import GetResource

api = application = falcon.API()


def load_trained_model():
    global model
    model = load_model(os.path.join(os.path.dirname(__file__), 'model/cnn_model.h5'))
    model._make_predict_function()  # make keras thread-safe
    return model


predict = GetResource(model=load_trained_model())
api.add_route('/predict', predict)

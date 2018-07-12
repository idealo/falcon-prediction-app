import falcon
from .predict import GetResource

api = application = falcon.API()

predict = GetResource()
api.add_route('/predict', predict)

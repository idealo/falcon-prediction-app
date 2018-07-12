import os
import base64
import falcon
from falcon import testing
from prediction_app import app, predict


class PredictionAppTest(testing.TestCase):
    def setUp(self):
        super(PredictionAppTest, self).setUp()
        self.app = app.api
        with open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data/four_test.png'), 'rb') as f:
            self.files = {'image': base64.b64encode(f.read()).decode('utf-8')}
        self.image = os.path.join(os.path.dirname(
            os.path.abspath(__file__)), 'data/four_test.png')

    def test_image_has_right_shape(self):
        shape = (1, 28, 28, 1)
        self.assertEqual(predict.convert_image(self.image).shape, shape)

    def test_prediction_status_is_200(self):
        """Test that the status code 200 is returned for get."""
        response = self.simulate_get('/predict')
        self.assertEqual(response.status, falcon.HTTP_OK)

    def test_prediction_are_correct(self):
        """Test that the right prediction is returned."""
        prediction = {u'prediction': '4'}
        response = self.simulate_post('/predict', json=self.files)
        self.assertEqual(response.json, prediction)

import os
import json
import base64
from locust import HttpLocust, TaskSet

with open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'src/tests/data/four_test.png'), 'rb') as f:
    request = {'image': base64.b64encode(f.read()).decode('utf-8')}

def get_predict(l):
    l.client.get('/predict')

def post_predict(l):
    headers = {'content-type': 'application/json'}
    l.client.post('/predict', data=json.dumps(request), headers=headers)

class UserBehavior(TaskSet):
    tasks = {post_predict: 1}

class WebsiteUser(HttpLocust):
    task_set = UserBehavior
    min_wait = 5000
    max_wait = 9000

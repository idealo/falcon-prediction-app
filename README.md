# Machine Learning Web API Example with Falcon

Simple example that uses [Falcon](https://falconframework.org/) to create a deep learning RESTful prediction service (simple convnet trained on the MNIST dataset). [Locust](https://locust.io/) is used for load testing.
[Gunicorn](http://gunicorn.org/) as WSGI HTTP Server and [nginx](https://www.nginx.com/) as HTTP proxy server.

This repository is no longer maintained and has been archived on January, 7th, 2025. 

## Getting Started

### Run prediction service

```
docker build -t falcon-prediction-app .
docker run -p 127.0.0.1:8000:8081 falcon-prediction-app
```

### Test prediction service

```
(echo -n '{"image": "'; base64 src/tests/data/four_test.png; echo '"}') |
curl -i -H "Content-Type: application/json" -d @- http://127.0.0.1:8000/predict
```

### Run unittests

```
pytest -s src/tests/
```

### Run load testing

```
locust -f load_testing.py --host=http://127.0.0.1:8000
```
Note: Access the Locust GUI via `http://localhost:8089/` to start load testing.

## Dependencies
- Python conda environment (install with `conda env create --file environment.yml`)
- Gunicorn
- Falcon
- Keras
- Tensorflow
- Pillow
- Locust

## Copyright
See [LICENSE](LICENSE) for details.

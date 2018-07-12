# Machine Learning Web API Example with Falcon

Simple example to use [Falcon](https://falconframework.org/) to create a RESTful prediction service (simple convnet trained on the MNIST dataset).

## Getting Started

### Run prediction service

```
gunicorn -b 0.0.0.0:8080 --reload src.prediction_app.app
```

### Test prediction service

```
(echo -n '{"image": "'; base64 src/tests/data/four_test.png; echo '"}') |
curl -i -H "Content-Type: application/json" -d @-  http://0.0.0.0:8080/predict
```

### Run unittests

```
pytest -s src/tests/
```

## Dependencies
- Python conda environment (install with `conda env create --file environment.yml`)
- Gunicorn
- Falcon
- Keras
- Tensorflow
- Pillow

## Copyright
See [LICENSE](LICENSE) for details.

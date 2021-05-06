from helloworld import helloworld as app

def test_hello_world():
    assert app.hello_world() == "Hello world!"
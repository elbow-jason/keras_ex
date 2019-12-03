from model_registry import (
    ModelRegistry,
    ModelAlreadyExistsError,
    NoSuchModelError,
)

# put some space around the obligatory keras stderr backend message
print("")
from keras.models import Sequential
from keras.layers import (
    Dense,
    Activation,
    Dropout,
    Flatten,
    Reshape,
    Permute,
    RepeatVector,
)
print("")

import numpy as np

from atoms import Atoms

from helpers import dict_to_erl_kwargs, erl_kwargs_to_dict

import os
TF_LOG = "TF_CPP_MIN_LOG_LEVEL"
os.environ[TF_LOG] = "3"

models = ModelRegistry()

def mute():
    os.environ[TF_LOG] = "3"
    return Atoms.ok()

def unmute():
    os.environ[TF_LOG] = "1"
    return Atoms.ok()

def sequential(name):
    models.add(name, Sequential())
    return dict_to_erl_kwargs({"name": name})

def dense(name, size, options):
    kwargs = erl_kwargs_to_dict(options)
    models.get(name).add(Dense(size, **kwargs))
    return dict_to_erl_kwargs({"size": size, "options": options})

def activation(name, activation_type, _options):
    models.get(name).add(Activation(activation_type))
    return dict_to_erl_kwargs({"activation_type": activation_type})

def dropout(name, rate, options):
    kwargs = erl_kwargs_to_dict(options)
    models.get(name).add(Dropout(rate, **kwargs))
    return dict_to_erl_kwargs(({"rate": rate, "options": options}))

def flatten(name, options):
    kwargs = erl_kwargs_to_dict(options)
    models.get(name).add(Flatten(**kwargs))
    return dict_to_erl_kwargs(kwargs)

def reshape(name, shape, options):
    kwargs = erl_kwargs_to_dict(options)
    models.get(name).add(Reshape(shape, **kwargs))
    return dict_to_erl_kwargs({"shape": shape, "options": options})

def permute(name, shape, options):
    kwargs = erl_kwargs_to_dict(options)
    models.get(name).add(Permute(shape, **kwargs))
    return dict_to_erl_kwargs({"shape": shape, "options": options})

def repeat_vector(name, factor):
    models.get(name).add(RepeatVector(factor))
    return dict_to_erl_kwargs({"factor": factor})

def compile_model(name, options):
    kwargs = erl_kwargs_to_dict(options)
    optimizer = kwargs.pop("optimizer")
    models.get(name).compile(optimizer, **kwargs)
    return dict_to_erl_kwargs({"optimizer": optimizer, "options": options})

def fit(name, data, labels, options):
    data = _list_of_np_arrays(data)
    labels = _list_of_np_arrays(labels)
    kwargs = erl_kwargs_to_dict(options)
    result = models.get(name).fit(data, labels, **kwargs)
    return (Atoms.ok(), _parse_fit_result(result))

def predict(name, data, options):
    data = _list_of_np_arrays(data)
    kwargs = erl_kwargs_to_dict(options)
    result = models.get(name).predict(data, **kwargs)
    return (Atoms.ok(), [float(x) for x in result])

def summary(name):
    models.get(name).summary()
    return Atoms.ok()

def model_names():
    return models.keys()

def _list_of_np_arrays(erl_items):
    head = erl_items[0]
    if isinstance(head, float):
        return np.array([ np.array(erl_items) ])
    if isinstance(head, list):
        return np.array([np.array(item) for item in erl_items])
    raise Exception("Unexpected unexpected input", erl_items)

def _parse_predict_result(result):
    return 

def _parse_fit_result(result):
    
    dct = result.__dict__
    params = dct.get("params") or {}
    history = dct.get("history") or {}
    dct = {
        "metrics": params.get("metrics"),
        "samples": params.get("samples"),
        "epochs": params.get("epochs"),
        "loss": _float(_list_last(history.get("loss"))),
    }
    return [(k, v) for (k, v) in dct.items() if v is not None]

def _get_in(dct, keys):
    try:
        key = keys.pop()
        if len(keys) == 0:
            return dct.get(key)
        return _get_in(dct.get(key), keys)
    except:
        return None
        

def _list_last(items):
    try:
        return items[len(items) - 1]
    except:
        return None

def _float(item):
    try:
        return float(item)
    except:
        return None
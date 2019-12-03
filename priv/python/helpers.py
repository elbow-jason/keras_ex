from atoms import Atoms

def get_type(item):
    return str(type(item))

def erl_kwargs_to_dict(items):
    return dict(list(items))

def dict_to_erl_kwargs(d):
    if isinstance(d, dict):
        return d.items()
    raise Exception("Cannot convert type {} to erl_kwargs".format(type(d)))

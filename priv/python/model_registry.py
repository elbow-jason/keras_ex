from atoms import Atoms

class NoSuchModelError(Exception): 
    def __init__(self, name):
        message = "Model \"{}\" does not exist".format(name)
        super(NoSuchModelError, self).__init__(message)
        self.name = name        
        

class ModelAlreadyExistsError(Exception):
    def __init__(self, name):
        message = "Model \"{}\" already exists".format(name)
        super(ModelAlreadyExistsError, self).__init__(message)
        self.name = name

class ModelRegistry(object):
    def __init__(self):
        self.models = dict()

    def get(self, name):
        model = self.models.get(name)
        if model is None:
            raise NoSuchModelError(name)
        return model
    
    def add(self, name, model):
        if self.models.has_key(name):
            raise ModelAlreadyExistsError(name)
        self.models[name] = model
    
    def keys(self):
        return self.models.keys()
    
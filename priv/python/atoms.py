from erlport.erlterms import Atom

class Atoms(object):
    @staticmethod
    def ok(): return Atom("ok")
    
    @staticmethod
    def error(): return Atom("error")

    @staticmethod
    def no_such_model(): return Atom("no_such_model")
    
    @staticmethod
    def model_already_exists(): return Atom("model_already_exists")

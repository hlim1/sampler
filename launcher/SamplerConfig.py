import gconf


########################################################################
#
#  GConf interaction, specialized for sampler
#


class SamplerConfig:

    def __init__(self, application):
        self.client = gconf.client_get_default()
        self.root = application.get('general', 'gconf-root')
        self.client.add_dir(self.root, gconf.CLIENT_PRELOAD_ONELEVEL)

    def __key(self, suffix):
        return self.root + '/' + suffix

    def __get_bool(self, name):
        return self.client.get_bool(self.__key(name))

    def __set_bool(self, name, value):
        self.client.set_bool(self.__key(name), value)

    def __get_int(self, name):
        return self.client.get_int(self.__key(name))

    def __set_int(self, name, value):
        return self.client.set_int(self.__key(name), value)

    def __get_string(self, name):
        return self.client.get_string(self.__key(name))

    def __set_string(self, name, value):
        return self.client.set_string(self.__key(name), value)

    __handle_bool = { 'get' : __get_bool,
                      'set' : __set_bool }

    __handle_int = { 'get' : __get_int,
                     'set' : __set_int }

    __handle_string = { 'get' : __get_string,
                        'set' : __set_string }

    __handlers = { 'asked' : __handle_bool,
                   'compression-level' : __handle_int,
                   'enabled' : __handle_bool,
                   'reporting-url' : __handle_string,
                   'sparsity' : __handle_int }

    def __getitem__(self, name):
        return SamplerConfig.__handlers[name]['get'](self, name)

    def __setitem__(self, name, value):
        SamplerConfig.__handlers[name]['set'](self, name, value)

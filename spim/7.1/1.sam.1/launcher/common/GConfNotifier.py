class GConfNotifier:
    def __init__(self, client, namespace, callback, data = None):
        self.__client = client
        self.__id = client.notify_add(namespace, callback, data)

    def __del__(self):
        if self.__id != None:
            self.__client.notify_remove(self.__id)
            self.__id = None

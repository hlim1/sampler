import Keys


class AppFinder(list):
    def __init__(self, client):
        self[0:0] = client.all_dirs(Keys.applications)

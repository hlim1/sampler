class AppFinder(list):
    def __init__(self, client):
        import Keys
        self.insert(0, client.all_dirs(Keys.applications))

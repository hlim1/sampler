import Launcher
import Uploader


def main(app, user, accept):
    '''Run the given application and possibly upload the results.'''
    if user.enabled() and user.sparsity() > 0:
        sparsity = user.sparsity()
        if sparsity > 0:
            outcome = Launcher.run_with_sampling(app, sparsity)
        Uploader.upload(app, user, outcome, accept)
        outcome.exit()
    else:
        Launcher.run_without_sampling(app)

import Launcher
import Uploader


def main(app, user):
    """Run the given application and possibly upload the results."""
    if user.enabled() and user.sparsity() > 0:
        outcome = Launcher.run_with_sampling(app, sparsity)
        Uploader.upload(app, user, outcome)
        outcome.exit()
    else:
        run(app)

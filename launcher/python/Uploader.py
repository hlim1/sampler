import RedirectHandler
import Upload

import urllib2


def __add_headers(upload, prefix, contributor):
    contribution = contributor.upload_headers()
    for key in contribution:
        upload.headers["Sampler-" + prefix + "-" + key] = contribution[key]


def upload(app, user, outcome):
    """Upload the results of a single run."""

    reporting_url = user.reporting_url()
    if reporting_url:

        # compress reports in preparation for upload
        compress_level = user.compression_level()
        if compress_level < 1 or compress_level > 9:
            compress_level = 9
        upload = Upload.Upload(outcome.reports, compress_level)

        # collect headers from various contributors
        upload.headers["sampler-uploader-version"] = "0.1"
        __add_headers(upload, "application", app)
        __add_headers(upload, "user", user)
        __add_headers(upload, "outcome", outcome)

        # install our special redirect hander
        redirect = RedirectHandler.RedirectHandler()
        urllib2.install_opener(urllib2.build_opener(redirect))

        # post the upload and read server's response
        request = urllib2.Request(reporting_url, upload.body(), upload.headers)
        reply = urllib2.urlopen(request)
        import shutil
        import sys

        # server may have requested a permanent URL change
        if redirect.permanent:
            user.change_reporting_url(redirect.permanent)

        # server may have requested a sparsity change
        print reply.info()
        if reply.info().has_key("Change-sparsity"):
            user.change_sparsity(int(reply.info()["Change-sparsity"]))

        # server may have posted a message for the user
        if reply.info()["Content-length"]:
            user.show_server_message(reply)

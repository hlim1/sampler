import urllib2

import RedirectHandler
import Upload


def __add_headers(upload, contributor):
    contribution = contributor.upload_headers()
    for key in contribution:
        upload.headers['sampler-' + key] = contribution[key]


def upload(app, user, outcome, accept):
    '''Upload the results of a single run.'''

    reporting_url = user.reporting_url()
    if reporting_url:

        # compress reports in preparation for upload
        compress_level = user.compression_level()
        if compress_level < 1 or compress_level > 9:
            compress_level = 9
        upload = Upload.Upload(outcome.reports, compress_level)

        # collect headers from various contributors
        upload.headers['sampler-uploader-version'] = '0.1'
        upload.headers['accept'] = accept
        __add_headers(upload, app)
        __add_headers(upload, outcome)

        # install our special redirect hander
        redirect = RedirectHandler.RedirectHandler()
        urllib2.install_opener(urllib2.build_opener(redirect))

        # post the upload and read server's response
        request = urllib2.Request(reporting_url, upload.body(), upload.headers)
        reply = urllib2.urlopen(request)

        # server may have requested a permanent URL change
        if redirect.permanent:
            # !!!: sanity check this before applying it
            # !!!: don't apply change if it is the same as the old value
            user.change_reporting_url(redirect.permanent)

        # server may have requested a sparsity change
        if reply.info().has_key('change-sparsity'):
            # !!!: sanity check this before applying it
            # !!!: don't apply change if it is the same as the old value
            user.change_sparsity(int(reply.info()['change-sparsity']))

        # server may have posted a message for the user
        if reply.info().has_key('content-length') and int(reply.info()['Content-length']):
            user.show_server_message(reply)

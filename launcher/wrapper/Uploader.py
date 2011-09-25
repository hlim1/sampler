import urllib2


def __add_headers(upload, contributor):
    contribution = contributor.upload_headers()
    for key in contribution:
        upload.headers['sampler-' + key] = contribution[key]


def upload(app, reporting_url, outcome, accept):
    '''Upload the results of a single run.'''

    if outcome.reports:

        # upload in the background, in case the network is slow
        import os
        if os.fork() > 0:
            return

        # compress reports in preparation for upload
        import Upload
        upload = Upload.Upload(outcome.reports)

        # collect headers from various contributors
        import SamplerConfig
        upload.headers['sampler-version'] = SamplerConfig.version
        upload.headers['accept'] = accept
        __add_headers(upload, app)
        __add_headers(upload, outcome)

        # post the upload and read server's response
        request = urllib2.Request(reporting_url, upload.body(), upload.headers)
        reply = urllib2.urlopen(request)

        # server may have posted a message for the user
        message = reply.read()
        if message and 'DISPLAY' in os.environ:
            base = reply.geturl()
            content_type = reply.info()['content-type']
            del reply
            import ServerMessage
            dialog = ServerMessage.ServerMessage(base, content_type, message)
            dialog.run()

        # child is done; exit without fanfare
        os._exit(0)

#!/usr/bin/python

import bonobo

import uploader


def bonobo_generic_factory_main(act_iid, factory_cb):
    factory = bonobo.GenericFactory(act_iid, factory_cb)
    if factory:
        bonobo.running_context_auto_exit_unref(factory)
        bonobo.main()
        return bonobo.debug_shutdown()
    else:
        return 1


def builder(factory, product):
    return uploader.Uploader()


bonobo_generic_factory_main("OAFIID:SamplerUploader_Factory:1.0", builder)

import sys

import pygtk
pygtk.require('2.0')
import gtk

import BaseUserConfig
import FirstTime
import SamplerConfig
import ServerMessage


class GnomeUserConfig (BaseUserConfig.BaseUserConfig):
    '''User preferences for instrumened GNOME applications..'''

    def __init__(self, dir, app):
        '''Look for preferences under GConf area for the given application.'''
        self.__gconfig = SamplerConfig.SamplerConfig(app)
        self.__app = app

    def enabled(self):
        '''Check whether sampling is enabled.'''

        # present first time dialog if we haven't already asked
        if not self.__gconfig['asked']:
            firstTime = FirstTime.FirstTime(self.__app, self.__gconfig)
            response = firstTime.run()
            firstTime.hide()
            if response != gtk.RESPONSE_OK:
                sys.exit(1)

            # wait for dialog to go away before launching main app
            while gtk.events_pending():
                gtk.main_iteration()

            # remember user preference for next time
            self.__gconfig['enabled'] = firstTime.enabled()
            self.__gconfig['asked'] = 1

        return self.__gconfig['enabled']

    def sparsity(self):
        '''Sparsity of sampled data.'''
        return self.__gconfig['sparsity']

    def reporting_url(self):
        '''Destination address for uploaded reports.'''
        return self.__gconfig['reporting-url']

    def compression_level(self):
        '''Level of compression for uploaded reports.'''
        return self.__gconfig['compression-level']

    def change_reporting_url(self, url):
        '''Record a new address for future uploads.'''
        self.__gconfig['reporting-url'] = url

    def change_sparsity(self, sparsity):
        '''Record a new sampling sparsity for future runs.'''
        self.__gconfig['sparsity'] = sparsity

    def show_server_message(self, reply):
        '''Show a server message in response to an upload.'''
        dialog = ServerMessage.ServerMessage(self.__app, reply)
        dialog.run()
        dialog.hide()

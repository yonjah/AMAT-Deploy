import requests
import os
import time
from urlparse import urljoin
from urllib import urlopen

try:
    import ijson
    HAVE_IJSON = True
except ImportError:
    HAVE_IJSON = False

from fame.common.utils import tempdir
from fame.common.exceptions import ModuleInitializationError, ModuleExecutionError
from fame.core.module import ProcessingModule

class viper(ProcessingModule):
    name = "viper"
    config = [
        {
            'name': 'api_endpoint_viper',
            'type': 'str',
            'default': 'http://viper_ip:8080',
            'description': "URL of viper's API endpoint."
        },
        {
            'name': 'web_endpoint_viper',
            'type': 'str',
            'default': 'http://viper_ip:8080',
            'description': "URL of viper's web interface."
        },
        {
        'name': 'allow_internet_access_viper',
        'type': 'bool',
        'default': True,
        'description': 'This allows full Internet access to the sandbox.',
        'option': True
        }
     ]
    def each_with_type(self, target, file_type):
        # Set root URLs
        self.results = dict()

        options = self.define_options()

        # First, submit the file / URL
        if file_type == 'url':
            self.submit_url(target, options)
        else:
            self.submit_file(target, options)

        return True

    def define_options(self):
        if self.allow_internet_access_viper:
            route = "internet" 
        else:
            route = "drop"
    
    def submit_file(self, filepath, options):
        url = urljoin(self.api_endpoint_viper, '/file/add')
        fp = open(filepath, 'rb')

        response = requests.post(url, files={'file': fp}, data=options)

    def submit_url(self, target_url, options):
        url = urljoin(self.api_endpoint_viper, '/file/add')
        options['url'] = target_url
        response = requests.post(url, data=options)

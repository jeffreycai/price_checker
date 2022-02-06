from prometheus_client import start_http_server, Summary

'''
PromeServer Class to handle http requests
'''
class PromeServer():

    ''' Static vars '''

    REQUEST_TIME  = Summary('request_processing_seconds', 'Time spent processing request')

    '''
    Start server
    '''
    def start(self, port):
        start_http_server(port)

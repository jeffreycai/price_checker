import urllib.request
import json

'''
A simple wrapper for web requests. Just to make it cleaner
'''
class Controller():

    ''' Static vars '''

    COINBASE_API_CURRENCIES  = 'https://api.coinbase.com/v2/currencies'
    COINBASE_API_SPOT_PRICES = 'https://api.coinbase.com/v2/prices/spot'

    def __init__(self, request_handler):
        '''
        Initializor
        '''
        self.handler                 = request_handler
        self.currency_code           = request_handler.path.lstrip('/')

    def send_text(self, context, response_code = 200):
        '''
        Send response text with a response code
        '''

        self.handler.send_response(response_code)
        self.handler.send_header("Content-type", "text/html")
        self.handler.end_headers()
        self.handler.wfile.write(bytes("<html><head><title>Coinbase API</title></head>", "utf-8"))
        self.handler.wfile.write(bytes("<body>", "utf-8"))
        self.handler.wfile.write(bytes(f"<p>{context}</p>", "utf-8"))
        self.handler.wfile.write(bytes("</body></html>", "utf-8"))
    
    def send_bad_request(self, context):
        '''
        Send 400 bad request
        '''
        self.send_text(f'Bad Request (400): {context}', 400)

    def send_server_error(self, context):
        '''
        Send 500 error
        '''
        self.send_text(f'Internal Server Error (500): {context}', 500)

    def coinbase_api_call(self, endpoint):
        '''
        Coinbase API call
        '''
        try:
            with urllib.request.urlopen(endpoint) as response:
                if response.code == 200:
                    return response.read()
                elif response.code.startswith('4'):
                    self.send_bad_request(response.read())
                elif response.code.startswith('5'):
                    self.send_server_error(response.read())
        except Exception as e:
            self.send_server_error(e)

    def get_avaiable_currencies(self):
        '''
        Call Coinbase API to get a list of all avaiable currencies support by Coinbase
        '''
        json_str = self.coinbase_api_call(f'{Controller.COINBASE_API_CURRENCIES}')
        json_obj = json.loads(json_str)

        currencies = []
        for entry in json_obj['data']:
            currencies.append(entry['id'])
        return currencies
        
    def get_spot_price(self, code):
        '''
        Call Coinbase API to get spot price of a specified currency
        '''
        json_str = self.coinbase_api_call(f'{Controller.COINBASE_API_SPOT_PRICES}?currency={self.currency_code}')
        json_obj = json.loads(json_str)

        return json_obj['data']

from http.server import BaseHTTPRequestHandler
from controller import Controller
from promeserver import PromeServer

'''
WebServer Class to handle http requests
'''
class WebServer(BaseHTTPRequestHandler):
    '''
    Parse Get query
    '''
    @PromeServer.REQUEST_TIME.time()
    def do_GET(self):
        path = self.path
        controller = Controller(self)
        code = controller.currency_code
        currencies = controller.get_avaiable_currencies() # all avaiable currencies

        # /
        # homepage shows a list of all available currencies
        if path == '/':
            li = ''
            for currency in currencies:
                li = li + f'<li><a href="/{currency}">{currency}</a></li>'

            controller.send_text(f"""
            <h1>Simple Coinbase Spot Price Checker</h1>
            <p>Available currencies</p>
            <ul>{li}</ul>
            """)

        # /health
        elif path == '/health':
            controller.send_text('Healthy')

        # /favicon.ico
        elif path == '/favicon.ico':
            controller.send_text('')

#        # /metrics
#        elif path == '/metrics':
#            report_metrics()

        # /<currency>
        else:
            try:
                # Check if currency code is valid
                # if valid, fetch price
                if code in currencies:
                    price = controller.get_spot_price(code)
                    controller.send_text(f"""
                    <p>
                        Spot price for <b style="color:red">{code}</b> is:
                        <ul>
                            <li><b>Base</b>: <b style="color:blue">{price['base']}</b></li>
                            <li><b>Currency</b>: <b style="color:blue">{price['currency']}</b></li>
                            <li><b>Amount</b>: <b style="color:blue">{price['amount']}</b></li>
                        </ul>

                        <a href='/'>Back Home</a>
                    </p>
                    """)
                # if not, 400 out
                else:
                    controller.send_bad_request(f'Can not find matching currency code <b>{code}</b>')
            except Exception as e:
                controller.send_bad_request(e)


#!/bin/env python3

from http.server import HTTPServer
from webserver import WebServer
from promeserver import PromeServer
import time

# Global vars
hostName = ""
serverPort = 8080
promePort = 8000

# main()
if __name__ == "__main__":        
    webServer = HTTPServer((hostName, serverPort), WebServer)
    print("Web Server started http://%s:%s" % (hostName, serverPort))

    promeServer = PromeServer()
    promeServer.start(promePort)
    print("Prometheus Server started http://%s:%s" % (hostName, promePort))

    try:
        webServer.serve_forever()
    except KeyboardInterrupt:
        pass

    webServer.server_close()
    print("Server stopped.")
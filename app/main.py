#!/bin/env python3

from http.server import HTTPServer
from webserver import WebServer
import time

# Global vars
hostName = ""
serverPort = 8080

# main()
if __name__ == "__main__":        
    webServer = HTTPServer((hostName, serverPort), WebServer)
    print("Server started http://%s:%s" % (hostName, serverPort))

    try:
        webServer.serve_forever()
    except KeyboardInterrupt:
        pass

    webServer.server_close()
    print("Server stopped.")
from http.server import BaseHTTPRequestHandler, HTTPServer
import sys

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"OK")
    
    def log_message(self, format, *args):
        pass

print("[HTTP] Server on :10000", flush=True)
HTTPServer(("0.0.0.0", 10000), Handler).serve_forever()
import sys
from http.server import BaseHTTPRequestHandler, HTTPServer

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"OK")
    
    def log_message(self, format, *args):
        pass

print("[HEALTH] Starting on port 10000", file=sys.stderr, flush=True)
HTTPServer(("0.0.0.0", 10000), Handler).serve_forever()
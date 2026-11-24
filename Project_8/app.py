import os
import socket
from datetime import datetime, timezone

from flask import Flask

app = Flask(__name__)

PAGE = """<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Project 8 - Docker App</title>
  <style>
    body { font-family: Arial, sans-serif; text-align: center; margin-top: 100px; background: #f4f7fb; color: #1f2d3d; }
    h1 { color: #0b5ed7; }
    .box { display: inline-block; padding: 30px 50px; background: white; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
    code { background: #eef2f7; padding: 2px 6px; border-radius: 4px; }
  </style>
</head>
<body>
  <div class="box">
    <h1>Hello from Docker!</h1>
    <p>This Flask app is running inside a container.</p>
    <p>Container ID (hostname): <code>__HOSTNAME__</code></p>
    <p>App version: <code>__VERSION__</code></p>
    <p>Server time (UTC): <code>__NOW__</code></p>
  </div>
</body>
</html>
"""


@app.route("/")
def home():
    now = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S")
    return (
        PAGE.replace("__HOSTNAME__", socket.gethostname())
        .replace("__VERSION__", os.environ.get("APP_VERSION", "1.0"))
        .replace("__NOW__", now)
    )


@app.route("/health")
def health():
    return {"status": "ok"}

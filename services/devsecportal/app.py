from flask import Flask, render_template, send_from_directory
import os

app = Flask(__name__)

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/artifacts/<path:path>")
def artifacts(path):
    return send_from_directory("artifacts", path)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=False)
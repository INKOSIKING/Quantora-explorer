from flask import Flask, request, jsonify
import secrets
import os

app = Flask(__name__)
SHARE_DIR = "code_snippets/"

@app.route("/share", methods=["POST"])
def share():
    code = request.json["code"]
    token = secrets.token_urlsafe(8)
    path = os.path.join(SHARE_DIR, f"{token}.py")
    with open(path, "w") as f:
        f.write(code)
    return jsonify({"share_url": f"/snippet/{token}"})

@app.route("/snippet/<token>")
def get_snippet(token):
    path = os.path.join(SHARE_DIR, f"{token}.py")
    if not os.path.exists(path):
        return "Not found", 404
    with open(path) as f:
        return f.read(), 200, {"Content-Type": "text/plain"}

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8100)
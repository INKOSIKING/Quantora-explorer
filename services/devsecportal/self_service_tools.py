from flask import Flask, request, jsonify
import subprocess

app = Flask(__name__)

@app.route("/scan/secrets", methods=["POST"])
def scan_secrets():
    repo = request.json["repo_path"]
    result = subprocess.check_output(["python", "scripts/secrets_discovery.py", "--repos", repo])
    return jsonify({"result": result.decode()})

@app.route("/scan/deps", methods=["POST"])
def scan_deps():
    repo = request.json["repo_path"]
    result = subprocess.check_output(["python", "scripts/verify_internal_deps.py", "--src", repo])
    return jsonify({"result": result.decode()})

# Add more endpoints for DLP, SBOM, etc.

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8090)
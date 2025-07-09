"""
Quantora Internal Access Request Portal
Owner: Comfort Lindokuhle Mhaleni, South Africa
"""
from flask import Flask, request, render_template

app = Flask(__name__)

@app.route("/", methods=["GET", "POST"])
def access_request():
    if request.method == "POST":
        # Process request and log for owner review
        return render_template("thankyou.html", owner="Comfort Lindokuhle Mhaleni")
    return render_template("request_access.html", owner="Comfort Lindokuhle Mhaleni")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8400)
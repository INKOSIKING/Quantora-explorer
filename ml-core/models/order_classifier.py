import pandas as pd
from sklearn.ensemble import RandomForestClassifier
import joblib

def train():
    df = pd.read_csv("../datasets/orders.csv")
    X = df[["quantity", "price"]]
    y = (df["label"] == "completed").astype(int)
    clf = RandomForestClassifier()
    clf.fit(X, y)
    joblib.dump(clf, "order_classifier.pkl")

def predict(quantity, price):
    clf = joblib.load("order_classifier.pkl")
    return clf.predict([[quantity, price]])[0]
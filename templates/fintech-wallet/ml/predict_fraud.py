import pandas as pd
from sklearn.ensemble import RandomForestClassifier

def train_and_predict():
    df = pd.read_csv("transactions.csv")
    X = df[["amount", "type"]]
    y = df["is_fraud"]
    clf = RandomForestClassifier()
    clf.fit(X, y)
    return clf.predict([[100, 1]]) # Example

if __name__ == "__main__":
    print(train_and_predict())
import pandas as pd
from sklearn.ensemble import IsolationForest
def detect_fraud(df):
    features = ["amount", "device_score", "country_risk"]
    model = IsolationForest()
    model.fit(df[features])
    df['is_fraud'] = model.predict(df[features]) == -1
    return df[df['is_fraud']]
# Example usage
if __name__ == "__main__":
    df = pd.read_csv("transactions.csv")
    print(detect_fraud(df))
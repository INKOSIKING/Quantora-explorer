import pandas as pd
from ml_core.models.order_classifier import train, predict

def run():
    train()
    print("Model trained and saved!")
    print("Prediction for 3 items at $30:", predict(3, 30))

if __name__ == "__main__":
    run()
"""
Quantora Private Notification System
Owner: Comfort Lindokuhle Mhaleni (South Africa)
"""
import sys

def send_owner_notification(event, details):
    owner = "Comfort Lindokuhle Mhaleni"
    country = "South Africa"
    message = f"[Quantora][OWNER: {owner} ({country})] Key Event: {event}\nDetails: {details}"
    # Integrate with internal messaging/alerting systems here
    print(message)

if __name__ == "__main__":
    event = sys.argv[1]
    details = sys.argv[2]
    send_owner_notification(event, details)
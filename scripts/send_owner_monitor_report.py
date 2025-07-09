"""
Internal Monitoring/Alerting Report Sender
Owner: Comfort Lindokuhle Mhaleni, South Africa
"""
def send_report(report):
    header = "[Quantora Monitoring]\nReport Owner: Comfort Lindokuhle Mhaleni (South Africa)\n"
    # Send to internal channel...
    print(header + report)
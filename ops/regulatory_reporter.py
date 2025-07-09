import os, json, smtplib
from datetime import datetime, timedelta
from email.message import EmailMessage

REPORT_DIR = "compliance/"
REGULATOR_EMAIL = "aml@regulator.example"
TAX_AUTHORITY_EMAIL = "tax@taxauthority.gov"
SMTP_SERVER = "smtp.company.com"

def gather_reports(since_days=1):
    reports = []
    cutoff = datetime.utcnow() - timedelta(days=since_days)
    for fname in os.listdir(REPORT_DIR):
        if fname.startswith("sar_") or fname.startswith("aml_"):
            fpath = os.path.join(REPORT_DIR, fname)
            if datetime.utcfromtimestamp(os.path.getmtime(fpath)) > cutoff:
                with open(fpath) as f:
                    reports.append(json.load(f))
    return reports

def send_email(to, subject, body):
    msg = EmailMessage()
    msg["From"] = "compliance@yourdomain.com"
    msg["To"] = to
    msg["Subject"] = subject
    msg.set_content(body)
    with smtplib.SMTP(SMTP_SERVER) as s:
        s.send_message(msg)

def main():
    reports = gather_reports()
    if reports:
        sar_body = json.dumps([r for r in reports if "sar" in r.get("reason", "").lower()], indent=2)
        aml_body = json.dumps([r for r in reports if "aml" in r.get("reason", "").lower()], indent=2)
        if sar_body:
            send_email(REGULATOR_EMAIL, "Daily SAR Report", sar_body)
        if aml_body:
            send_email(REGULATOR_EMAIL, "Daily AML Report", aml_body)
    # Tax reporting (monthly)
    if datetime.utcnow().day == 1:
        with open(REPORT_DIR + "tax_report.json") as f:
            send_email(TAX_AUTHORITY_EMAIL, "Monthly Exchange Tax Report", f.read())

if __name__ == "__main__":
    main()
import re

def dlp_check(output: str) -> bool:
    PII_PATTERNS = [
        r"\b\d{3}-\d{2}-\d{4}\b",  # SSN
        r"\b4[0-9]{12}(?:[0-9]{3})?\b",  # Visa
        r"\b\d{5}(?:-\d{4})?\b",  # US Zip
        r"\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b",  # Email
    ]
    for pat in PII_PATTERNS:
        if re.search(pat, output, re.IGNORECASE):
            return False
    return True

def safe_llm_response(response: str) -> str:
    if not dlp_check(response):
        return "[REDACTED: Output blocked by DLP policy]"
    return response
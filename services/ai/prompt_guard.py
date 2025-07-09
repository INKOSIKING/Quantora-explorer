import re

SUSPICIOUS_PATTERNS = [
    r"(ignore|disregard|bypass)[\s\S]{0,20}(instructions|rules|security)",
    r"(write|give|return)[\s\S]{0,20}(password|secret|token)",
    r"(?i)system prompt",
    r"(?i)simulate an admin",
]

def is_prompt_safe(prompt: str) -> bool:
    for pattern in SUSPICIOUS_PATTERNS:
        if re.search(pattern, prompt, re.IGNORECASE):
            return False
    return True

# Usage in your API:
def handle_llm_request(prompt):
    if not is_prompt_safe(prompt):
        raise Exception("Prompt rejected: possible injection or abuse detected")
    # Proceed with LLM inference
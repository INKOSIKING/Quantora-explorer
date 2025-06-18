#!/usr/bin/env python3
import sys
import random
import re
from pathlib import Path

def mutate_solidity_code(code: str) -> str:
    mutations = [
        lambda c: re.sub(r'\buint\b', 'uint256', c),
        lambda c: re.sub(r'\brequire\s*(.*?);', r'require(\1, "Failed");', c),
        lambda c: re.sub(r'\bassert\b', 'require', c),
        lambda c: re.sub(r'\bpublic\b', random.choice(['external', 'internal', 'private']), c),
        lambda c: c.replace('>=', '>')
    ]
    for mutate in random.sample(mutations, k=random.randint(1, len(mutations))):
        code = mutate(code)
    return code

def main():
    if len(sys.argv) != 3:
        print("Usage: mutator.py <input.sol> <output.sol>")
        sys.exit(1)

    input_file = Path(sys.argv[1])
    output_file = Path(sys.argv[2])

    if not input_file.exists():
        print(f"File not found: {input_file}")
        sys.exit(1)

    with input_file.open("r") as f:
        code = f.read()

    mutated = mutate_solidity_code(code)

    with output_file.open("w") as f:
        f.write(mutated)

    print(f"✅ Mutated contract saved to {output_file}")

if __name__ == "__main__":
    main()

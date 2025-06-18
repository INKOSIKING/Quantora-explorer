#!/bin/bash

# Count lines in common code files
find . -type f \
  -name "*.rs" -o \
  -name "*.ts" -o \
  -name "*.tsx" -o \
  -name "*.sh" -o \
  -name "*.sql" -o \
  -name "*.py" -o \
  -name "*.js" \
  -print0 | xargs -0 wc -l | tail -n 1

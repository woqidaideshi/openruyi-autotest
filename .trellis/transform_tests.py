"""Batch transform all test.sh to show per-step PASS/FAIL counts."""
import os, re

BASE = 'e:/code/openruyi-autotest/tests/functional'

# Find all test.sh
test_files = []
for root, dirs, files in os.walk(BASE):
    for f in files:
        if f == 'test.sh':
            test_files.append(os.path.join(root, f))

print(f'Found {len(test_files)} test scripts\n')

new_rlRun = '''PASS=0; FAIL=0
rlRun() {
  _cmd="$1"; shift
  [ "$1" = "0" ] && shift
  _desc="$*"
  if eval "$_cmd" 2>&1; then
    PASS=$((PASS+1)); echo "[PASS] $_desc"
  else
    FAIL=$((FAIL+1)); echo "[FAIL] $_desc"
  fi
}'''

summary_marker = 'echo "$PASS passed, $FAIL failed"'

for path in sorted(test_files):
    pkg = os.path.basename(os.path.dirname(path))
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original = content
    
    # 1. Replace rlRun function definition
    # Pattern: rlRun() { eval "$1" 2>&1; return $?; }
    old_rlRun = r'rlRun\(\)\s*\{\s*eval\s+"\$1"\s+2>&1\s*;\s*return\s+\$\?\s*;\s*\}'
    new_rlRun_block = 'PASS=0; FAIL=0\\nrlRun() {\\n  _cmd="$1"; shift\\n  [ "$1" = "0" ] && shift\\n  _desc="$*"\\n  if eval "$_cmd" 2>&1; then\\n    PASS=$((PASS+1)); echo "[PASS] $_desc"\\n  else\\n    FAIL=$((FAIL+1)); echo "[FAIL] $_desc"\\n  fi\\n}'
    content = re.sub(old_rlRun, new_rlRun_block, content)
    
    # 2. Replace final "All xxx functional tests passed!" with summary
    old_ending = r'(echo\s+)"(All\s+\S+\s+functional\s+tests\s+passed!)"'
    new_ending = r'echo "$PASS passed, $FAIL failed"\n\1"\2"'
    content = re.sub(old_ending, new_ending, content)
    
    if content != original:
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f'  UPDATED: {pkg}')
    else:
        print(f'  SKIP: {pkg} (no match)')

print('\nDone!')

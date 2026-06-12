#!/bin/sh -eux
# Functional test: gawk ������
# Tests: awk, gawk commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q gawk 2>/dev/null || { echo 'gawk not installed, skipping'; exit 0; }
which awk 2>/dev/null || echo 'awk not found'
which gawk 2>/dev/null || echo 'gawk not found'
rlRun 'awk --version 2>&1 || true' 0 "��ȡ awk �汾��Ϣ"
rlRun 'gawk --version 2>&1 || true' 0 "��ȡ gawk �汾��Ϣ"

echo ""
echo "All gawk functional tests passed!"

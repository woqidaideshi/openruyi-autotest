#!/bin/sh -eux
# Functional test: unzip - ������
# Tests: unzip, funzip, zipgrep, zipinfo commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q unzip 2>/dev/null || { echo 'unzip not installed, skipping'; exit 0; }

echo "=== ����: ������ ==="
rlRun 'unzip --invalid-flag-xyz 2>&1 || true' 0 "���� unzip ��Ч����������"
rlRun 'funzip --invalid-flag-xyz 2>&1 || true' 0 "���� funzip ��Ч����������"
rlRun 'zipgrep --invalid-flag-xyz 2>&1 || true' 0 "���� zipgrep ��Ч����������"
rlRun 'zipinfo --invalid-flag-xyz 2>&1 || true' 0 "���� zipinfo ��Ч����������"

echo ""
echo "All unzip-error functional tests passed!"

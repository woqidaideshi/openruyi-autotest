#!/bin/sh -eux
# Functional test: dc - �沨��������
# Tests: dc commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q bc 2>/dev/null || { echo 'bc not installed, skipping'; exit 0; }
which dc 2>/dev/null || echo 'dc not found'

echo "=== ����: dc �������� ==="
rlRun 'echo "1 1 + p" | dc' 0 "dc �ӷ�"
rlRun 'echo "10 3 - p" | dc' 0 "dc ����"
rlRun 'echo "6 7 * p" | dc' 0 "dc �˷�"
rlRun 'echo "100 3 / p" | dc' 0 "dc ����"
rlRun 'echo "4 k 1 3 / p" | dc' 0 "dc ��������"

echo ""
echo "All dc-basic functional tests passed!"

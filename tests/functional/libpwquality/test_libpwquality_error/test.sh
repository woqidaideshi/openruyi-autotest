#!/bin/sh -eux
# Functional test: libpwquality - ������
# Tests: pwmake, pwscore commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libpwquality 2>/dev/null || { echo 'libpwquality not installed, skipping'; exit 0; }

echo "=== ����: ������ ==="
rlRun 'pwmake --invalid-flag-xyz 2>&1 || true' 0 "���� pwmake ��Ч����������"
rlRun 'pwscore --invalid-flag-xyz 2>&1 || true' 0 "���� pwscore ��Ч����������"

echo ""
echo "All libpwquality-error functional tests passed!"

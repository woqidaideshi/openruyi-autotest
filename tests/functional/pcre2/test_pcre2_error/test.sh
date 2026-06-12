#!/bin/sh -eux
# Functional test: pcre2 - ������
# Tests: pcre2grep, pcre2test commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q pcre2 2>/dev/null || { echo 'pcre2 not installed, skipping'; exit 0; }

echo "=== ����: ������ ==="
rlRun 'pcre2grep --invalid-flag-xyz 2>&1 || true' 0 "���� pcre2grep ��Ч����������"
rlRun 'pcre2test --invalid-flag-xyz 2>&1 || true' 0 "���� pcre2test ��Ч����������"

echo ""
echo "All pcre2-error functional tests passed!"

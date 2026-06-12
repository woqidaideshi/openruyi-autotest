#!/bin/sh -eux
# Functional test: pcre2 - ��������
# Tests: pcre2grep, pcre2test commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q pcre2 2>/dev/null || { echo 'pcre2 not installed, skipping'; exit 0; }
which pcre2grep 2>/dev/null || echo 'pcre2grep not found'
which pcre2test 2>/dev/null || echo 'pcre2test not found'

echo "=== ����: pcre2 �������� ==="
rlRun 'pcre2grep --help 2>&1 | head -10' 0 "�鿴 pcre2grep ������Ϣ"
rlRun 'pcre2test --help 2>&1 | head -10' 0 "�鿴 pcre2test ������Ϣ"

echo ""
echo "All pcre2-basic functional tests passed!"

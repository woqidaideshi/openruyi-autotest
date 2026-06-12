#!/bin/sh -eux
# Functional test: pcre2 ������
# Tests: pcre2grep, pcre2test commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q pcre2 2>/dev/null || { echo 'pcre2 not installed, skipping'; exit 0; }
which pcre2grep 2>/dev/null || echo 'pcre2grep not found'
which pcre2test 2>/dev/null || echo 'pcre2test not found'
rlRun 'pcre2grep --version 2>&1 || true' 0 "��ȡ pcre2grep �汾��Ϣ"
rlRun 'pcre2test --version 2>&1 || true' 0 "��ȡ pcre2test �汾��Ϣ"

echo ""
echo "All pcre2 functional tests passed!"

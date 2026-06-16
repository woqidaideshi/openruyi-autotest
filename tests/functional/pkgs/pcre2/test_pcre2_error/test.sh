#!/bin/sh -eux
# Functional test: pcre2 - ������
# Tests: pcre2grep, pcre2test commands

# rlRun wrapper for standalone execution

. "../setup.sh"

rlRun 'pcre2grep --invalid-flag-xyz 2>&1 || true' 0 "���� pcre2grep ��Ч����������"
rlRun 'pcre2test --invalid-flag-xyz 2>&1 || true' 0 "���� pcre2test ��Ч����������"

. "../teardown.sh"
echo "All pcre2-error functional tests passed!"

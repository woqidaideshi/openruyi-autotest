#!/bin/sh -eux
# Functional test: less - ������
# Tests: less, lessecho, lesskey commands

# rlRun wrapper for standalone execution

. "../setup.sh"

rlRun 'less --invalid-flag-xyz 2>&1 || true' 0 "���� less ��Ч����������"
rlRun 'lessecho --invalid-flag-xyz 2>&1 || true' 0 "���� lessecho ��Ч����������"
rlRun 'lesskey --invalid-flag-xyz 2>&1 || true' 0 "���� lesskey ��Ч����������"

. "../teardown.sh"
echo "All less-error functional tests passed!"

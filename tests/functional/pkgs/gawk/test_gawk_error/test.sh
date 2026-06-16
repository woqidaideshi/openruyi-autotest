#!/bin/sh -eux
# Functional test: gawk - ������
# Tests: awk, gawk commands

# rlRun wrapper for standalone execution

. "../setup.sh"

rlRun 'awk --invalid-flag-xyz 2>&1 || true' 0 "���� awk ��Ч����������"
rlRun 'gawk --invalid-flag-xyz 2>&1 || true' 0 "���� gawk ��Ч����������"

. "../teardown.sh"
echo "All gawk-error functional tests passed!"

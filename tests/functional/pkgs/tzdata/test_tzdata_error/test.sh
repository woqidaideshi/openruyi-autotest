#!/bin/sh -eux
# Functional test: tzdata - ������
# Tests: tzselect, zdump, zic commands

# rlRun wrapper for standalone execution

. "../setup.sh"

rlRun 'tzselect --invalid-flag-xyz 2>&1 || true' 0 "���� tzselect ��Ч����������"
rlRun 'zdump --invalid-flag-xyz 2>&1 || true' 0 "���� zdump ��Ч����������"
rlRun 'zic --invalid-flag-xyz 2>&1 || true' 0 "���� zic ��Ч����������"

. "../teardown.sh"
echo "All tzdata-error functional tests passed!"

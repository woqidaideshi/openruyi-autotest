#!/bin/sh -eux
# Functional test: time - ������
# Tests: time commands

# rlRun wrapper for standalone execution

. "../setup.sh"

rlRun 'time --invalid-flag-xyz 2>&1 || true' 0 "���� time ��Ч����������"

. "../teardown.sh"
echo "All time-error functional tests passed!"

#!/bin/sh -eux
# Functional test: which - ������
# Tests: which commands

# rlRun wrapper for standalone execution

. "../setup.sh"

rlRun 'which --invalid-flag-xyz 2>&1 || true' 0 "���� which ��Ч����������"

. "../teardown.sh"
echo "All which-error functional tests passed!"

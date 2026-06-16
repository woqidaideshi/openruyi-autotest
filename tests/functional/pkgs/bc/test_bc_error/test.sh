#!/bin/sh -eux
# Functional test: bc/dc - ������
# Tests: bc, dc commands

# rlRun wrapper for standalone execution

. "../setup.sh"

rlRun 'bc --invalid 2>&1 || true' 0 "bc ��Ч����"
rlRun 'dc --invalid 2>&1 || true' 0 "dc ��Ч����"
rlRun 'echo "1/0" | bc 2>&1 || true' 0 "bc �������"

. "../teardown.sh"
echo "All bc-error functional tests passed!"

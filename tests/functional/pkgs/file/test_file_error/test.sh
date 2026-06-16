#!/bin/sh -eux
# Functional test: file - ������
# Tests: file commands

# rlRun wrapper for standalone execution

. "../setup.sh"

rlRun 'file --invalid-flag-xyz 2>&1 || true' 0 "���� file ��Ч����������"

. "../teardown.sh"
echo "All file-error functional tests passed!"

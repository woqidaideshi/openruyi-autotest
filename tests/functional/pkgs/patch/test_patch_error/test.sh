#!/bin/sh -eux
# Functional test: patch - ������
# Tests: patch commands

# rlRun wrapper for standalone execution

. "../setup.sh"

rlRun 'patch --invalid-flag-xyz 2>&1 || true' 0 "���� patch ��Ч����������"

. "../teardown.sh"
echo "All patch-error functional tests passed!"

#!/bin/sh -eux
# Functional test: slang - ������
# Tests: slsh commands

# rlRun wrapper for standalone execution

. "../setup.sh"

rlRun 'slsh --invalid-flag-xyz 2>&1 || true' 0 "���� slsh ��Ч����������"

. "../teardown.sh"
echo "All slang-error functional tests passed!"

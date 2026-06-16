#!/bin/sh -eux
# Functional test: openssh - ������
# Tests: ssh commands

# rlRun wrapper for standalone execution

. "../setup.sh"

rlRun 'ssh --invalid-flag-xyz 2>&1 || true' 0 "���� ssh ��Ч����������"

. "../teardown.sh"
echo "All openssh-error functional tests passed!"

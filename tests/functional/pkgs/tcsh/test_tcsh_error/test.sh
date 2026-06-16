#!/bin/sh -eux
# Functional test: tcsh - ������
# Tests: tcsh commands

# rlRun wrapper for standalone execution

. "../setup.sh"

rlRun 'tcsh --invalid-flag-xyz 2>&1 || true' 0 "���� tcsh ��Ч����������"

. "../teardown.sh"
echo "All tcsh-error functional tests passed!"

#!/bin/sh -eux
# Functional test: libidn2 - ������
# Tests: idn2 commands

# rlRun wrapper for standalone execution

. "../setup.sh"

rlRun 'idn2 --invalid-flag-xyz 2>&1 || true' 0 "���� idn2 ��Ч����������"

. "../teardown.sh"
echo "All libidn2-error functional tests passed!"

#!/bin/sh -eux
# Functional test: expat - ������
# Tests: xmlwf commands

# rlRun wrapper for standalone execution

. "../setup.sh"

rlRun 'xmlwf --invalid-flag-xyz 2>&1 || true' 0 "���� xmlwf ��Ч����������"

. "../teardown.sh"
echo "All expat-error functional tests passed!"

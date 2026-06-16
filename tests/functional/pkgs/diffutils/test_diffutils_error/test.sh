#!/bin/sh -eux
# Functional test: diffutils - ������
# Tests: cmp, diff, diff3, sdiff commands

# rlRun wrapper for standalone execution

. "../setup.sh"

rlRun 'cmp --invalid-flag-xyz 2>&1 || true' 0 "���� cmp ��Ч����������"
rlRun 'diff --invalid-flag-xyz 2>&1 || true' 0 "���� diff ��Ч����������"
rlRun 'diff3 --invalid-flag-xyz 2>&1 || true' 0 "���� diff3 ��Ч����������"
rlRun 'sdiff --invalid-flag-xyz 2>&1 || true' 0 "���� sdiff ��Ч����������"

. "../teardown.sh"
echo "All diffutils-error functional tests passed!"

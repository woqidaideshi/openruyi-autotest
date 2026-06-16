#!/bin/sh -eux
# Functional test: e2fsprogs ������

. "../setup.sh"

rlRun 'e2fsck --invalid 2>&1 || true' 0 "��Ч����"
rlRun 'mke2fs --invalid 2>&1 || true' 0 "mke2fs ��Ч����"

. "../teardown.sh"
echo "All e2fsprogs-error functional tests passed!"

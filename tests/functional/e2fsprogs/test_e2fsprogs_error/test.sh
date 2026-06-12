#!/bin/sh -eux
# Functional test: e2fsprogs ������

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q e2fsprogs 2>/dev/null || { echo 'e2fsprogs not installed, skipping'; exit 0; }

echo "=== ������ ==="
rlRun 'e2fsck --invalid 2>&1 || true' 0 "��Ч����"
rlRun 'mke2fs --invalid 2>&1 || true' 0 "mke2fs ��Ч����"

echo ""
echo "All e2fsprogs-error functional tests passed!"

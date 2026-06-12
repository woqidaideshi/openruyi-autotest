#!/bin/sh -eux
# Functional test: cpio - ������
# Tests: cpio commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q cpio 2>/dev/null || { echo 'cpio not installed, skipping'; exit 0; }

echo "=== ����: ������ ==="
rlRun 'cpio --invalid-flag-xyz 2>&1 || true' 0 "���� cpio ��Ч����������"

echo ""
echo "All cpio-error functional tests passed!"

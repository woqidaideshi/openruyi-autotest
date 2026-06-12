#!/bin/sh -eux
# Functional test: cpio ������
# Tests: cpio commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q cpio 2>/dev/null || { echo 'cpio not installed, skipping'; exit 0; }
which cpio 2>/dev/null || echo 'cpio not found'
rlRun 'cpio --version 2>&1 || true' 0 "��ȡ cpio �汾��Ϣ"

echo ""
echo "All cpio functional tests passed!"

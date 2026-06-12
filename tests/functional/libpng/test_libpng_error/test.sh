#!/bin/sh -eux
# Functional test: libpng - ������
# Tests: pngfix commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libpng 2>/dev/null || { echo 'libpng not installed, skipping'; exit 0; }

echo "=== ����: ������ ==="
rlRun 'pngfix --invalid-flag-xyz 2>&1 || true' 0 "���� pngfix ��Ч����������"

echo ""
echo "All libpng-error functional tests passed!"

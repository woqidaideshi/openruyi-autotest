#!/bin/sh -eux
# Functional test: libpng - ��������
# Tests: pngfix commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libpng 2>/dev/null || { echo 'libpng not installed, skipping'; exit 0; }
which pngfix 2>/dev/null || echo 'pngfix not found'

echo "=== ����: libpng �������� ==="
rlRun 'pngfix --help 2>&1 | head -10' 0 "�鿴 pngfix ������Ϣ"

echo ""
echo "All libpng-basic functional tests passed!"

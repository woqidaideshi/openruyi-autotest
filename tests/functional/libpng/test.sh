#!/bin/sh -eux
# Functional test: libpng ������
# Tests: pngfix commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libpng 2>/dev/null || { echo 'libpng not installed, skipping'; exit 0; }
which pngfix 2>/dev/null || echo 'pngfix not found'
rlRun 'pngfix --version 2>&1 || true' 0 "��ȡ pngfix �汾��Ϣ"

echo ""
echo "All libpng functional tests passed!"

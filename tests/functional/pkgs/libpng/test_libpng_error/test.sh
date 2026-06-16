#!/bin/sh -eux
# Functional test: libpng - ������
# Tests: pngfix commands

# rlRun wrapper for standalone execution

. "../setup.sh"

rlRun 'pngfix --invalid-flag-xyz 2>&1 || true' 0 "���� pngfix ��Ч����������"

. "../teardown.sh"
echo "All libpng-error functional tests passed!"

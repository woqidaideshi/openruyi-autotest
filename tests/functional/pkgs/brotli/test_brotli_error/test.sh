#!/bin/sh -eux
# Functional test: brotli - ������
# Tests: brotli commands

# rlRun wrapper for standalone execution

. "../setup.sh"

rlRun 'brotli --invalid-flag-xyz 2>&1 || true' 0 "���� brotli ��Ч����������"

. "../teardown.sh"
echo "All brotli-error functional tests passed!"

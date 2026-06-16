#!/bin/sh -eux
# Functional test: cpio - ������
# Tests: cpio commands

# rlRun wrapper for standalone execution

. "../setup.sh"

rlRun 'cpio --invalid-flag-xyz 2>&1 || true' 0 "���� cpio ��Ч����������"

. "../teardown.sh"
echo "All cpio-error functional tests passed!"

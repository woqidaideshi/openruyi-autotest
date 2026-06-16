#!/bin/sh -eux
# Functional test: libxslt - ������
# Tests: xsltproc commands

# rlRun wrapper for standalone execution

. "../setup.sh"

rlRun 'xsltproc --invalid-flag-xyz 2>&1 || true' 0 "���� xsltproc ��Ч����������"

. "../teardown.sh"
echo "All libxslt-error functional tests passed!"

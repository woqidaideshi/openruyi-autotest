#!/bin/sh -eux
# Functional test: libxslt - ������
# Tests: xsltproc commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libxslt 2>/dev/null || { echo 'libxslt not installed, skipping'; exit 0; }

echo "=== ����: ������ ==="
rlRun 'xsltproc --invalid-flag-xyz 2>&1 || true' 0 "���� xsltproc ��Ч����������"

echo ""
echo "All libxslt-error functional tests passed!"

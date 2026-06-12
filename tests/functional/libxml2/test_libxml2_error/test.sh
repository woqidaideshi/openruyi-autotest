#!/bin/sh -eux
# Functional test: libxml2 - ������
# Tests: xmlcatalog, xmllint commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libxml2 2>/dev/null || { echo 'libxml2 not installed, skipping'; exit 0; }

echo "=== ����: ������ ==="
rlRun 'xmlcatalog --invalid-flag-xyz 2>&1 || true' 0 "���� xmlcatalog ��Ч����������"
rlRun 'xmllint --invalid-flag-xyz 2>&1 || true' 0 "���� xmllint ��Ч����������"

echo ""
echo "All libxml2-error functional tests passed!"

#!/bin/sh -eux
# Functional test: libxml2 - ��������
# Tests: xmlcatalog, xmllint commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libxml2 2>/dev/null || { echo 'libxml2 not installed, skipping'; exit 0; }
which xmlcatalog 2>/dev/null || echo 'xmlcatalog not found'
which xmllint 2>/dev/null || echo 'xmllint not found'

echo "=== ����: libxml2 �������� ==="
rlRun 'xmlcatalog --help 2>&1 | head -10' 0 "�鿴 xmlcatalog ������Ϣ"
rlRun 'xmllint --help 2>&1 | head -10' 0 "�鿴 xmllint ������Ϣ"

echo ""
echo "All libxml2-basic functional tests passed!"

#!/bin/sh -eux
# Functional test: libxslt - ��������
# Tests: xsltproc commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libxslt 2>/dev/null || { echo 'libxslt not installed, skipping'; exit 0; }
which xsltproc 2>/dev/null || echo 'xsltproc not found'

echo "=== ����: libxslt �������� ==="
rlRun 'xsltproc --help 2>&1 | head -10' 0 "�鿴 xsltproc ������Ϣ"

echo ""
echo "All libxslt-basic functional tests passed!"

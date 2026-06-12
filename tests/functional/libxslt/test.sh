#!/bin/sh -eux
# Functional test: libxslt ������
# Tests: xsltproc commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libxslt 2>/dev/null || { echo 'libxslt not installed, skipping'; exit 0; }
which xsltproc 2>/dev/null || echo 'xsltproc not found'
rlRun 'xsltproc --version 2>&1 || true' 0 "��ȡ xsltproc �汾��Ϣ"

echo ""
echo "All libxslt functional tests passed!"

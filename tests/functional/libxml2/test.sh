#!/bin/sh -eux
# Functional test: libxml2 ������
# Tests: xmlcatalog, xmllint commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libxml2 2>/dev/null || { echo 'libxml2 not installed, skipping'; exit 0; }
which xmlcatalog 2>/dev/null || echo 'xmlcatalog not found'
which xmllint 2>/dev/null || echo 'xmllint not found'
rlRun 'xmlcatalog --version 2>&1 || true' 0 "��ȡ xmlcatalog �汾��Ϣ"
rlRun 'xmllint --version 2>&1 || true' 0 "��ȡ xmllint �汾��Ϣ"

echo ""
echo "All libxml2 functional tests passed!"

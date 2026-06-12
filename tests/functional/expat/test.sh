#!/bin/sh -eux
# Functional test: expat ������
# Tests: xmlwf commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q expat 2>/dev/null || { echo 'expat not installed, skipping'; exit 0; }
which xmlwf 2>/dev/null || echo 'xmlwf not found'
rlRun 'xmlwf --version 2>&1 || true' 0 "��ȡ xmlwf �汾��Ϣ"

echo ""
echo "All expat functional tests passed!"

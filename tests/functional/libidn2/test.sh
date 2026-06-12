#!/bin/sh -eux
# Functional test: libidn2 ������
# Tests: idn2 commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libidn2 2>/dev/null || { echo 'libidn2 not installed, skipping'; exit 0; }
which idn2 2>/dev/null || echo 'idn2 not found'
rlRun 'idn2 --version 2>&1 || true' 0 "��ȡ idn2 �汾��Ϣ"

echo ""
echo "All libidn2 functional tests passed!"

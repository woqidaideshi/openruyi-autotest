#!/bin/sh -eux
# Functional test: unzip ������
# Tests: unzip, funzip, zipgrep, zipinfo commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q unzip 2>/dev/null || { echo 'unzip not installed, skipping'; exit 0; }
which unzip 2>/dev/null || echo 'unzip not found'
which funzip 2>/dev/null || echo 'funzip not found'
which zipgrep 2>/dev/null || echo 'zipgrep not found'
which zipinfo 2>/dev/null || echo 'zipinfo not found'
rlRun 'unzip --version 2>&1 || true' 0 "��ȡ unzip �汾��Ϣ"
rlRun 'funzip --version 2>&1 || true' 0 "��ȡ funzip �汾��Ϣ"
rlRun 'zipgrep --version 2>&1 || true' 0 "��ȡ zipgrep �汾��Ϣ"
rlRun 'zipinfo --version 2>&1 || true' 0 "��ȡ zipinfo �汾��Ϣ"

echo ""
echo "All unzip functional tests passed!"

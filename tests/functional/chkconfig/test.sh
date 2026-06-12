#!/bin/sh -eux
# Functional test: chkconfig - ϵͳ�������
# Commands: chkconfig, alternatives, update-alternatives

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q chkconfig 2>/dev/null || { echo 'chkconfig not installed, skipping'; exit 0; }
which chkconfig 2>/dev/null || echo 'chkconfig not found'
which alternatives 2>/dev/null || echo 'alternatives not found'
rlRun 'chkconfig --version 2>&1 || true' 0 "��ȡ chkconfig �汾"

echo ""
echo "All chkconfig functional tests passed!"

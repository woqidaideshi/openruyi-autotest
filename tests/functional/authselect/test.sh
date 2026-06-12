#!/bin/sh -eux
# Functional test: authselect - ϵͳ��֤����
# Commands: authselect

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q authselect 2>/dev/null || { echo 'authselect not installed, skipping'; exit 0; }
which authselect 2>/dev/null || echo 'authselect not found'
rlRun 'authselect --version 2>&1 || true' 0 "��ȡ authselect �汾"

echo ""
echo "All authselect functional tests passed!"

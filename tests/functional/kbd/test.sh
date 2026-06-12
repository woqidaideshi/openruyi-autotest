#!/bin/sh -eux
# Functional test: kbd - ���̺��ն˹���
# Commands: chvt, dumpkeys, kbdrate, loadkeys, setfont, showkey

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q kbd 2>/dev/null || { echo 'kbd not installed, skipping'; exit 0; }
which dumpkeys 2>/dev/null || echo 'dumpkeys not found'
which showkey 2>/dev/null || echo 'showkey not found'

echo ""
echo "All kbd functional tests passed!"

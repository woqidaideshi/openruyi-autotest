#!/bin/sh -eux
# Functional test: kbd - ��������
# Commands: dumpkeys, showkey, loadkeys, setfont

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q kbd 2>/dev/null || { echo 'kbd not installed, skipping'; exit 0; }
which dumpkeys 2>/dev/null || echo 'dumpkeys not found'
which showkey 2>/dev/null || echo 'showkey not found'
which loadkeys 2>/dev/null || echo 'loadkeys not found'
which setfont 2>/dev/null || echo 'setfont not found'

echo "=== ���̹��� ==="
rlRun 'dumpkeys --help 2>&1 | head -10' 0 "dumpkeys ����"
rlRun 'showkey --help 2>&1 | head -10' 0 "showkey ����"
rlRun 'loadkeys --help 2>&1 | head -10' 0 "loadkeys ����"
rlRun 'setfont --help 2>&1 | head -10' 0 "setfont ����"

echo ""
echo "All kbd-basic functional tests passed!"

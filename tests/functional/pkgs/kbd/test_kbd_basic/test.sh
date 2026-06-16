#!/bin/sh -eux
# Functional test: kbd - ��������
# Commands: dumpkeys, showkey, loadkeys, setfont

. "../setup.sh"

echo "=== ���̹��� ==="
rlRun 'dumpkeys --help 2>&1 | head -10' 0 "dumpkeys ����"
rlRun 'showkey --help 2>&1 | head -10' 0 "showkey ����"
rlRun 'loadkeys --help 2>&1 | head -10' 0 "loadkeys ����"
rlRun 'setfont --help 2>&1 | head -10' 0 "setfont ����"

. "../teardown.sh"
echo "All kbd-basic functional tests passed!"

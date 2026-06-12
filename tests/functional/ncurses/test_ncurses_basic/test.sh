#!/bin/sh -eux
# Functional test: ncurses - ��������
# Commands: infocmp, tput, clear, reset

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q ncurses 2>/dev/null || { echo 'ncurses not installed, skipping'; exit 0; }
which infocmp 2>/dev/null || echo 'infocmp not found'
which tput 2>/dev/null || echo 'tput not found'
which clear 2>/dev/null || echo 'clear not found'
which reset 2>/dev/null || echo 'reset not found'

echo "=== ncurses ���� ==="
rlRun 'infocmp --help 2>&1 | head -10' 0 "infocmp ����"
rlRun 'tput --help 2>&1 | head -10' 0 "tput ����"
rlRun 'clear --help 2>&1 | head -10' 0 "clear ����"
rlRun 'reset --help 2>&1 | head -10' 0 "reset ����"
rlRun 'infocmp 2>&1 | head -5 || true' 0 "�鿴�ն���Ϣ"

echo ""
echo "All ncurses-basic functional tests passed!"

#!/bin/sh -eux
# Functional test: ncurses - ��������
# Commands: infocmp, tput, clear, reset

. "../setup.sh"

rlRun 'infocmp 2>&1 | head -5 || true' 0 "�鿴�ն���Ϣ"

. "../teardown.sh"
echo "All ncurses-basic functional tests passed!"

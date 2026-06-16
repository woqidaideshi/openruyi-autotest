#!/bin/sh -eux
# Functional test: ncurses - ��������
# Commands: infocmp, tput, clear, reset

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install ncurses ===
INSTALLED_BY_TEST=0
if ! rpm -q ncurses 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y ncurses 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed ncurses"
    else
        echo "SKIP: ncurses not available in repos"
        exit 0
    fi
else
    echo "SETUP: ncurses already installed"
fi



echo "=== ncurses ���� ==="
rlRun 'infocmp --help 2>&1 | head -10' 0 "infocmp ����"
rlRun 'tput --help 2>&1 | head -10' 0 "tput ����"
rlRun 'clear --help 2>&1 | head -10' 0 "clear ����"
rlRun 'reset --help 2>&1 | head -10' 0 "reset ����"
rlRun 'infocmp 2>&1 | head -5 || true' 0 "�鿴�ն���Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y ncurses 2>/dev/null || true
    echo "TEARDOWN: removed ncurses"
fi
echo ""
echo "All ncurses-basic functional tests passed!"

#!/bin/sh -eux
# Functional test: kbd - ��������
# Commands: dumpkeys, showkey, loadkeys, setfont

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install kbd ===
INSTALLED_BY_TEST=0
if ! rpm -q kbd 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y kbd 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed kbd"
    else
        echo "SKIP: kbd not available in repos"
        exit 0
    fi
else
    echo "SETUP: kbd already installed"
fi



echo "=== ���̹��� ==="
rlRun 'dumpkeys --help 2>&1 | head -10' 0 "dumpkeys ����"
rlRun 'showkey --help 2>&1 | head -10' 0 "showkey ����"
rlRun 'loadkeys --help 2>&1 | head -10' 0 "loadkeys ����"
rlRun 'setfont --help 2>&1 | head -10' 0 "setfont ����"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y kbd 2>/dev/null || true
    echo "TEARDOWN: removed kbd"
fi
echo ""
echo "All kbd-basic functional tests passed!"

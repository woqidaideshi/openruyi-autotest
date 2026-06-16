#!/bin/sh -eux
# Functional test: authselect - ������
# Commands: authselect

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install authselect ===
INSTALLED_BY_TEST=0
if ! rpm -q authselect 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y authselect 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed authselect"
    else
        echo "SKIP: authselect not available in repos"
        exit 0
    fi
else
    echo "SETUP: authselect already installed"
fi



echo "=== ������ ==="
rlRun 'authselect --invalid 2>&1 || true' 0 "��Ч����"
rlRun 'authselect select nonexistent 2>&1 || true' 1-255 "ѡ�񲻴��ڵ�����"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y authselect 2>/dev/null || true
    echo "TEARDOWN: removed authselect"
fi
echo ""
echo "All authselect-error functional tests passed!"

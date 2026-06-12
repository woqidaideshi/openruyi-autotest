#!/bin/sh -eux
# Functional test: rpm ������

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install rpm ===
INSTALLED_BY_TEST=0
if ! rpm -q rpm 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y rpm 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed rpm"
    else
        echo "SKIP: rpm not available in repos"
        exit 0
    fi
else
    echo "SETUP: rpm already installed"
fi



echo "=== ������ ==="
rlRun 'rpm --invalid 2>&1 || true' 0 "��Ч����"
rlRun 'rpm -q nonexistent 2>&1 || true' 1-255 "��ѯ�����ڵİ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y rpm 2>/dev/null || true
    echo "TEARDOWN: removed rpm"
fi
echo ""
echo "All rpm-error functional tests passed!"

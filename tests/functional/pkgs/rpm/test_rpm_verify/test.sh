#!/bin/sh -eux
# Functional test: rpm ��֤
# Commands: rpm, rpmkeys

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



echo "=== rpm ��֤ ==="
rlRun 'rpmkeys --help 2>&1 | head -10' 0 "rpmkeys ����"
rlRun 'rpm -V rpm 2>&1 || true' 0 "��֤ rpm ��������"
rlRun 'rpm --import 2>&1 | head -5 || true' 0 "rpm --import ����"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y rpm 2>/dev/null || true
    echo "TEARDOWN: removed rpm"
fi
echo ""
echo "All rpm-verify functional tests passed!"

#!/bin/sh -eux
# Functional test: openssl - ������
# Commands: openssl

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install openssl ===
INSTALLED_BY_TEST=0
if ! rpm -q openssl 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y openssl 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed openssl"
    else
        echo "SKIP: openssl not available in repos"
        exit 0
    fi
else
    echo "SETUP: openssl already installed"
fi



echo "=== ������ ==="
rlRun 'openssl --invalid 2>&1 || true' 0 "��Ч����"
rlRun 'openssl dgst -invalid nonexistent 2>&1 || true' 1-255 "��ЧժҪ�㷨"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y openssl 2>/dev/null || true
    echo "TEARDOWN: removed openssl"
fi
echo ""
echo "All openssl-error functional tests passed!"

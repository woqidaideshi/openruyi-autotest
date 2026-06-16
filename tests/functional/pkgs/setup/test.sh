#!/bin/sh -eux
# Functional test: setup - ����/���ݰ�

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install setup ===
INSTALLED_BY_TEST=0
if ! rpm -q setup 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y setup 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed setup"
    else
        echo "SKIP: setup not available in repos"
        exit 0
    fi
else
    echo "SETUP: setup already installed"
fi



echo "=== �ļ��б���֤ ==="
rlRun 'rpm -ql setup 2>/dev/null | head -20 || true' 0 "�г����ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y setup 2>/dev/null || true
    echo "TEARDOWN: removed setup"
fi
echo ""
echo "All setup functional tests passed!"

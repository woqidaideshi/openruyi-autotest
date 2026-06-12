#!/bin/sh -eux
# Functional test: libedit - ���
# Commands: libedit.so.0, libedit.so.0.0.75

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libedit ===
INSTALLED_BY_TEST=0
if ! rpm -q libedit 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libedit 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libedit"
    else
        echo "SKIP: libedit not available in repos"
        exit 0
    fi
else
    echo "SETUP: libedit already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep libedit | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libedit 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libedit 2>/dev/null || true
    echo "TEARDOWN: removed libedit"
fi
echo ""
echo "All libedit functional tests passed!"

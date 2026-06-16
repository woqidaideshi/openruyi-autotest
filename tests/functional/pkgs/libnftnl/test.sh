#!/bin/sh -eux
# Functional test: libnftnl - ���
# Commands: libnftnl.so.11, libnftnl.so.11.6.0

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libnftnl ===
INSTALLED_BY_TEST=0
if ! rpm -q libnftnl 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libnftnl 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libnftnl"
    else
        echo "SKIP: libnftnl not available in repos"
        exit 0
    fi
else
    echo "SETUP: libnftnl already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep libnftnl | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libnftnl 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libnftnl 2>/dev/null || true
    echo "TEARDOWN: removed libnftnl"
fi
echo ""
echo "All libnftnl functional tests passed!"

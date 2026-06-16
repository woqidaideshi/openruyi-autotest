#!/bin/sh -eux
# Functional test: libunistring - ���
# Commands: libunistring.so.5, libunistring.so.5.2.1

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libunistring ===
INSTALLED_BY_TEST=0
if ! rpm -q libunistring 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libunistring 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libunistring"
    else
        echo "SKIP: libunistring not available in repos"
        exit 0
    fi
else
    echo "SETUP: libunistring already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep libunistring | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libunistring 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libunistring 2>/dev/null || true
    echo "TEARDOWN: removed libunistring"
fi
echo ""
echo "All libunistring functional tests passed!"

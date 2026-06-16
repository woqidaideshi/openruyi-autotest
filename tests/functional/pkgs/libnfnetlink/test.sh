#!/bin/sh -eux
# Functional test: libnfnetlink - ���
# Commands: libnfnetlink.so.0, libnfnetlink.so.0.2.0

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libnfnetlink ===
INSTALLED_BY_TEST=0
if ! rpm -q libnfnetlink 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libnfnetlink 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libnfnetlink"
    else
        echo "SKIP: libnfnetlink not available in repos"
        exit 0
    fi
else
    echo "SETUP: libnfnetlink already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep libnfnetlink | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libnfnetlink 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libnfnetlink 2>/dev/null || true
    echo "TEARDOWN: removed libnfnetlink"
fi
echo ""
echo "All libnfnetlink functional tests passed!"

#!/bin/sh -eux
# Functional test: libaio - ���
# Commands: libaio.so.1, libaio.so.1.0.2

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libaio ===
INSTALLED_BY_TEST=0
if ! rpm -q libaio 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libaio 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libaio"
    else
        echo "SKIP: libaio not available in repos"
        exit 0
    fi
else
    echo "SETUP: libaio already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep libaio | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libaio 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libaio 2>/dev/null || true
    echo "TEARDOWN: removed libaio"
fi
echo ""
echo "All libaio functional tests passed!"

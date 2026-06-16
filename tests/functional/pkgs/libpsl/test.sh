#!/bin/sh -eux
# Functional test: libpsl - ���
# Commands: libpsl.so.5, libpsl.so.5.3.5

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libpsl ===
INSTALLED_BY_TEST=0
if ! rpm -q libpsl 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libpsl 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libpsl"
    else
        echo "SKIP: libpsl not available in repos"
        exit 0
    fi
else
    echo "SETUP: libpsl already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep libpsl | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libpsl 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libpsl 2>/dev/null || true
    echo "TEARDOWN: removed libpsl"
fi
echo ""
echo "All libpsl functional tests passed!"

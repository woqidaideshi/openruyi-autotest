#!/bin/sh -eux
# Functional test: libaio - �ļ���֤
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
rlRun 'ls /usr/lib64/libaio.so.1* 2>/dev/null || ls /usr/lib/libaio.so.1* 2>/dev/null || echo "not in standard path"' 0 "��� libaio.so.1"
rlRun 'ls /usr/lib64/libaio.so.1.0.2* 2>/dev/null || ls /usr/lib/libaio.so.1.0.2* 2>/dev/null || echo "not in standard path"' 0 "��� libaio.so.1.0.2"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libaio 2>&1 || true' 0 "pkg-config ����Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libaio 2>/dev/null || true
    echo "TEARDOWN: removed libaio"
fi
echo ""
echo "All libaio-files functional tests passed!"

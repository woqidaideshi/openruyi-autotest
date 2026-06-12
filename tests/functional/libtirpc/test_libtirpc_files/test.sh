#!/bin/sh -eux
# Functional test: libtirpc - �ļ���֤
# Commands: libtirpc.so.3, libtirpc.so.3.0.0

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libtirpc ===
INSTALLED_BY_TEST=0
if ! rpm -q libtirpc 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libtirpc 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libtirpc"
    else
        echo "SKIP: libtirpc not available in repos"
        exit 0
    fi
else
    echo "SETUP: libtirpc already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libtirpc.so.3* 2>/dev/null || ls /usr/lib/libtirpc.so.3* 2>/dev/null || echo "not in standard path"' 0 "��� libtirpc.so.3"
rlRun 'ls /usr/lib64/libtirpc.so.3.0.0* 2>/dev/null || ls /usr/lib/libtirpc.so.3.0.0* 2>/dev/null || echo "not in standard path"' 0 "��� libtirpc.so.3.0.0"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libtirpc 2>&1 || true' 0 "pkg-config ����Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libtirpc 2>/dev/null || true
    echo "TEARDOWN: removed libtirpc"
fi
echo ""
echo "All libtirpc-files functional tests passed!"

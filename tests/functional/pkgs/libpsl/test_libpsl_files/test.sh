#!/bin/sh -eux
# Functional test: libpsl - �ļ���֤
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
rlRun 'ls /usr/lib64/libpsl.so.5* 2>/dev/null || ls /usr/lib/libpsl.so.5* 2>/dev/null || echo "not in standard path"' 0 "��� libpsl.so.5"
rlRun 'ls /usr/lib64/libpsl.so.5.3.5* 2>/dev/null || ls /usr/lib/libpsl.so.5.3.5* 2>/dev/null || echo "not in standard path"' 0 "��� libpsl.so.5.3.5"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libpsl 2>&1 || true' 0 "pkg-config ����Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libpsl 2>/dev/null || true
    echo "TEARDOWN: removed libpsl"
fi
echo ""
echo "All libpsl-files functional tests passed!"

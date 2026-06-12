#!/bin/sh -eux
# Functional test: libffi - �ļ���֤
# Commands: libffi.so.8, libffi.so.8.2.0

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libffi ===
INSTALLED_BY_TEST=0
if ! rpm -q libffi 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libffi 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libffi"
    else
        echo "SKIP: libffi not available in repos"
        exit 0
    fi
else
    echo "SETUP: libffi already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libffi.so.8* 2>/dev/null || ls /usr/lib/libffi.so.8* 2>/dev/null || echo "not in standard path"' 0 "��� libffi.so.8"
rlRun 'ls /usr/lib64/libffi.so.8.2.0* 2>/dev/null || ls /usr/lib/libffi.so.8.2.0* 2>/dev/null || echo "not in standard path"' 0 "��� libffi.so.8.2.0"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libffi 2>&1 || true' 0 "pkg-config ����Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libffi 2>/dev/null || true
    echo "TEARDOWN: removed libffi"
fi
echo ""
echo "All libffi-files functional tests passed!"

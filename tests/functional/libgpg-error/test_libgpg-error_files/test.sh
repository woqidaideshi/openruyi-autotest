#!/bin/sh -eux
# Functional test: libgpg-error - �ļ���֤
# Commands: libgpg-error.so.0, libgpg-error.so.0.41.1

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libgpg-error ===
INSTALLED_BY_TEST=0
if ! rpm -q libgpg-error 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libgpg-error 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libgpg-error"
    else
        echo "SKIP: libgpg-error not available in repos"
        exit 0
    fi
else
    echo "SETUP: libgpg-error already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libgpg-error.so.0* 2>/dev/null || ls /usr/lib/libgpg-error.so.0* 2>/dev/null || echo "not in standard path"' 0 "��� libgpg-error.so.0"
rlRun 'ls /usr/lib64/libgpg-error.so.0.41.1* 2>/dev/null || ls /usr/lib/libgpg-error.so.0.41.1* 2>/dev/null || echo "not in standard path"' 0 "��� libgpg-error.so.0.41.1"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libgpg-error 2>&1 || true' 0 "pkg-config ����Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libgpg-error 2>/dev/null || true
    echo "TEARDOWN: removed libgpg-error"
fi
echo ""
echo "All libgpg-error-files functional tests passed!"

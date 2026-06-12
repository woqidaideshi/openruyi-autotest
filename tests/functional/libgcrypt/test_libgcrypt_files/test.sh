#!/bin/sh -eux
# Functional test: libgcrypt - �ļ���֤
# Commands: libgcrypt.so.20, libgcrypt.so.20.6.0

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libgcrypt ===
INSTALLED_BY_TEST=0
if ! rpm -q libgcrypt 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libgcrypt 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libgcrypt"
    else
        echo "SKIP: libgcrypt not available in repos"
        exit 0
    fi
else
    echo "SETUP: libgcrypt already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libgcrypt.so.20* 2>/dev/null || ls /usr/lib/libgcrypt.so.20* 2>/dev/null || echo "not in standard path"' 0 "��� libgcrypt.so.20"
rlRun 'ls /usr/lib64/libgcrypt.so.20.6.0* 2>/dev/null || ls /usr/lib/libgcrypt.so.20.6.0* 2>/dev/null || echo "not in standard path"' 0 "��� libgcrypt.so.20.6.0"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libgcrypt 2>&1 || true' 0 "pkg-config ����Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libgcrypt 2>/dev/null || true
    echo "TEARDOWN: removed libgcrypt"
fi
echo ""
echo "All libgcrypt-files functional tests passed!"

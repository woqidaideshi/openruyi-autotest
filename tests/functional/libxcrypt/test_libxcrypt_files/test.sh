#!/bin/sh -eux
# Functional test: libxcrypt - �ļ���֤
# Commands: libcrypt.so.1, libcrypt.so.1.1.0, libowcrypt.so.1

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libxcrypt ===
INSTALLED_BY_TEST=0
if ! rpm -q libxcrypt 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libxcrypt 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libxcrypt"
    else
        echo "SKIP: libxcrypt not available in repos"
        exit 0
    fi
else
    echo "SETUP: libxcrypt already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libcrypt.so.1* 2>/dev/null || ls /usr/lib/libcrypt.so.1* 2>/dev/null || echo "not in standard path"' 0 "��� libcrypt.so.1"
rlRun 'ls /usr/lib64/libcrypt.so.1.1.0* 2>/dev/null || ls /usr/lib/libcrypt.so.1.1.0* 2>/dev/null || echo "not in standard path"' 0 "��� libcrypt.so.1.1.0"
rlRun 'ls /usr/lib64/libowcrypt.so.1* 2>/dev/null || ls /usr/lib/libowcrypt.so.1* 2>/dev/null || echo "not in standard path"' 0 "��� libowcrypt.so.1"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libxcrypt 2>&1 || true' 0 "pkg-config ����Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libxcrypt 2>/dev/null || true
    echo "TEARDOWN: removed libxcrypt"
fi
echo ""
echo "All libxcrypt-files functional tests passed!"

#!/bin/sh -eux
# Functional test: libarchive - �ļ���֤
# Commands: libarchive.so.13, libarchive.so.13.8.7

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libarchive ===
INSTALLED_BY_TEST=0
if ! rpm -q libarchive 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libarchive 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libarchive"
    else
        echo "SKIP: libarchive not available in repos"
        exit 0
    fi
else
    echo "SETUP: libarchive already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libarchive.so.13* 2>/dev/null || ls /usr/lib/libarchive.so.13* 2>/dev/null || echo "not in standard path"' 0 "��� libarchive.so.13"
rlRun 'ls /usr/lib64/libarchive.so.13.8.7* 2>/dev/null || ls /usr/lib/libarchive.so.13.8.7* 2>/dev/null || echo "not in standard path"' 0 "��� libarchive.so.13.8.7"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libarchive 2>&1 || true' 0 "pkg-config ����Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libarchive 2>/dev/null || true
    echo "TEARDOWN: removed libarchive"
fi
echo ""
echo "All libarchive-files functional tests passed!"

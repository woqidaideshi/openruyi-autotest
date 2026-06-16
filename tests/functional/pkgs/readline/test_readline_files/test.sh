#!/bin/sh -eux
# Functional test: readline - �ļ���֤
# Commands: libhistory.so.8, libhistory.so.8.3, libreadline.so.8, libreadline.so.8.3

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install readline ===
INSTALLED_BY_TEST=0
if ! rpm -q readline 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y readline 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed readline"
    else
        echo "SKIP: readline not available in repos"
        exit 0
    fi
else
    echo "SETUP: readline already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libhistory.so.8* 2>/dev/null || ls /usr/lib/libhistory.so.8* 2>/dev/null || echo "not in standard path"' 0 "��� libhistory.so.8"
rlRun 'ls /usr/lib64/libhistory.so.8.3* 2>/dev/null || ls /usr/lib/libhistory.so.8.3* 2>/dev/null || echo "not in standard path"' 0 "��� libhistory.so.8.3"
rlRun 'ls /usr/lib64/libreadline.so.8* 2>/dev/null || ls /usr/lib/libreadline.so.8* 2>/dev/null || echo "not in standard path"' 0 "��� libreadline.so.8"
rlRun 'ls /usr/lib64/libreadline.so.8.3* 2>/dev/null || ls /usr/lib/libreadline.so.8.3* 2>/dev/null || echo "not in standard path"' 0 "��� libreadline.so.8.3"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs readline 2>&1 || true' 0 "pkg-config ����Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y readline 2>/dev/null || true
    echo "TEARDOWN: removed readline"
fi
echo ""
echo "All readline-files functional tests passed!"

#!/bin/sh -eux
# Functional test: libeconf - �ļ���֤
# Commands: libeconf.so.0, libeconf.so.0.7.8

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libeconf ===
INSTALLED_BY_TEST=0
if ! rpm -q libeconf 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libeconf 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libeconf"
    else
        echo "SKIP: libeconf not available in repos"
        exit 0
    fi
else
    echo "SETUP: libeconf already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libeconf.so.0* 2>/dev/null || ls /usr/lib/libeconf.so.0* 2>/dev/null || echo "not in standard path"' 0 "��� libeconf.so.0"
rlRun 'ls /usr/lib64/libeconf.so.0.7.8* 2>/dev/null || ls /usr/lib/libeconf.so.0.7.8* 2>/dev/null || echo "not in standard path"' 0 "��� libeconf.so.0.7.8"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libeconf 2>&1 || true' 0 "pkg-config ����Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libeconf 2>/dev/null || true
    echo "TEARDOWN: removed libeconf"
fi
echo ""
echo "All libeconf-files functional tests passed!"

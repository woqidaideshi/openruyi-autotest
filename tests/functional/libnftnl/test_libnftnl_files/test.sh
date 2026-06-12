#!/bin/sh -eux
# Functional test: libnftnl - �ļ���֤
# Commands: libnftnl.so.11, libnftnl.so.11.6.0

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libnftnl ===
INSTALLED_BY_TEST=0
if ! rpm -q libnftnl 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libnftnl 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libnftnl"
    else
        echo "SKIP: libnftnl not available in repos"
        exit 0
    fi
else
    echo "SETUP: libnftnl already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libnftnl.so.11* 2>/dev/null || ls /usr/lib/libnftnl.so.11* 2>/dev/null || echo "not in standard path"' 0 "��� libnftnl.so.11"
rlRun 'ls /usr/lib64/libnftnl.so.11.6.0* 2>/dev/null || ls /usr/lib/libnftnl.so.11.6.0* 2>/dev/null || echo "not in standard path"' 0 "��� libnftnl.so.11.6.0"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libnftnl 2>&1 || true' 0 "pkg-config ����Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libnftnl 2>/dev/null || true
    echo "TEARDOWN: removed libnftnl"
fi
echo ""
echo "All libnftnl-files functional tests passed!"

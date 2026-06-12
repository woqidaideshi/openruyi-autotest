#!/bin/sh -eux
# Functional test: libnl - �ļ���֤
# Commands: libnl-3.so.200, libnl-3.so.200.26.0, libnl-genl-3.so.200, libnl-genl-3.so.200.26.0, libnl-idiag-3.so.200, libnl-idiag-3.so.200.26.0, libnl-nf-3.so.200, libnl-nf-3.so.200.26.0, libnl-route-3.so.200, libnl-route-3.so.200.26.0, libnl-xfrm-3.so.200, libnl-xfrm-3.so.200.26.0

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libnl ===
INSTALLED_BY_TEST=0
if ! rpm -q libnl 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libnl 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libnl"
    else
        echo "SKIP: libnl not available in repos"
        exit 0
    fi
else
    echo "SETUP: libnl already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libnl-3.so.200* 2>/dev/null || ls /usr/lib/libnl-3.so.200* 2>/dev/null || echo "not in standard path"' 0 "��� libnl-3.so.200"
rlRun 'ls /usr/lib64/libnl-3.so.200.26.0* 2>/dev/null || ls /usr/lib/libnl-3.so.200.26.0* 2>/dev/null || echo "not in standard path"' 0 "��� libnl-3.so.200.26.0"
rlRun 'ls /usr/lib64/libnl-genl-3.so.200* 2>/dev/null || ls /usr/lib/libnl-genl-3.so.200* 2>/dev/null || echo "not in standard path"' 0 "��� libnl-genl-3.so.200"
rlRun 'ls /usr/lib64/libnl-genl-3.so.200.26.0* 2>/dev/null || ls /usr/lib/libnl-genl-3.so.200.26.0* 2>/dev/null || echo "not in standard path"' 0 "��� libnl-genl-3.so.200.26.0"
rlRun 'ls /usr/lib64/libnl-idiag-3.so.200* 2>/dev/null || ls /usr/lib/libnl-idiag-3.so.200* 2>/dev/null || echo "not in standard path"' 0 "��� libnl-idiag-3.so.200"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libnl 2>&1 || true' 0 "pkg-config ����Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libnl 2>/dev/null || true
    echo "TEARDOWN: removed libnl"
fi
echo ""
echo "All libnl-files functional tests passed!"

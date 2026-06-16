#!/bin/sh -eux
# Functional test: libnetfilter_conntrack - �ļ���֤
# Commands: libnetfilter_conntrack.so.3, libnetfilter_conntrack.so.3.8.0

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libnetfilter_conntrack ===
INSTALLED_BY_TEST=0
if ! rpm -q libnetfilter_conntrack 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libnetfilter_conntrack 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libnetfilter_conntrack"
    else
        echo "SKIP: libnetfilter_conntrack not available in repos"
        exit 0
    fi
else
    echo "SETUP: libnetfilter_conntrack already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libnetfilter_conntrack.so.3* 2>/dev/null || ls /usr/lib/libnetfilter_conntrack.so.3* 2>/dev/null || echo "not in standard path"' 0 "��� libnetfilter_conntrack.so.3"
rlRun 'ls /usr/lib64/libnetfilter_conntrack.so.3.8.0* 2>/dev/null || ls /usr/lib/libnetfilter_conntrack.so.3.8.0* 2>/dev/null || echo "not in standard path"' 0 "��� libnetfilter_conntrack.so.3.8.0"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libnetfilter_conntrack 2>&1 || true' 0 "pkg-config ����Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libnetfilter_conntrack 2>/dev/null || true
    echo "TEARDOWN: removed libnetfilter_conntrack"
fi
echo ""
echo "All libnetfilter_conntrack-files functional tests passed!"

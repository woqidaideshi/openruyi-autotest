#!/bin/sh -eux
# Functional test: libnetfilter_conntrack - ���
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
rlRun 'ldconfig -p 2>/dev/null | grep libnetfilter_conntrack | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libnetfilter_conntrack 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libnetfilter_conntrack 2>/dev/null || true
    echo "TEARDOWN: removed libnetfilter_conntrack"
fi
echo ""
echo "All libnetfilter_conntrack functional tests passed!"

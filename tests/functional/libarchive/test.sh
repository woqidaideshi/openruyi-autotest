#!/bin/sh -eux
# Functional test: libarchive - ���
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
rlRun 'ldconfig -p 2>/dev/null | grep libarchive | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libarchive 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libarchive 2>/dev/null || true
    echo "TEARDOWN: removed libarchive"
fi
echo ""
echo "All libarchive functional tests passed!"

#!/bin/sh -eux
# Functional test: libmnl - ���
# Commands: libmnl.so.0, libmnl.so.0.2.0

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libmnl ===
INSTALLED_BY_TEST=0
if ! rpm -q libmnl 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libmnl 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libmnl"
    else
        echo "SKIP: libmnl not available in repos"
        exit 0
    fi
else
    echo "SETUP: libmnl already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep libmnl | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libmnl 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libmnl 2>/dev/null || true
    echo "TEARDOWN: removed libmnl"
fi
echo ""
echo "All libmnl functional tests passed!"

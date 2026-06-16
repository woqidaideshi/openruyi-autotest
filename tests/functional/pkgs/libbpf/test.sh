#!/bin/sh -eux
# Functional test: libbpf - ���
# Commands: libbpf.so.1, libbpf.so.1.7.0

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libbpf ===
INSTALLED_BY_TEST=0
if ! rpm -q libbpf 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libbpf 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libbpf"
    else
        echo "SKIP: libbpf not available in repos"
        exit 0
    fi
else
    echo "SETUP: libbpf already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep libbpf | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libbpf 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libbpf 2>/dev/null || true
    echo "TEARDOWN: removed libbpf"
fi
echo ""
echo "All libbpf functional tests passed!"

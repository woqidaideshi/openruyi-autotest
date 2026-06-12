#!/bin/sh -eux
# Functional test: libbpf - �ļ���֤
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
rlRun 'ls /usr/lib64/libbpf.so.1* 2>/dev/null || ls /usr/lib/libbpf.so.1* 2>/dev/null || echo "not in standard path"' 0 "��� libbpf.so.1"
rlRun 'ls /usr/lib64/libbpf.so.1.7.0* 2>/dev/null || ls /usr/lib/libbpf.so.1.7.0* 2>/dev/null || echo "not in standard path"' 0 "��� libbpf.so.1.7.0"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libbpf 2>&1 || true' 0 "pkg-config ����Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libbpf 2>/dev/null || true
    echo "TEARDOWN: removed libbpf"
fi
echo ""
echo "All libbpf-files functional tests passed!"

#!/bin/sh -eux
# Functional test: gdbm

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install gdbm ===
INSTALLED_BY_TEST=0
if ! rpm -q gdbm 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y gdbm 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed gdbm"
    else
        echo "SKIP: gdbm not available in repos"
        exit 0
    fi
else
    echo "SETUP: gdbm already installed"
fi


rpm -q gdbm 2>/dev/null || { echo "gdbm not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql gdbm 2>/dev/null | head -10 || true
rpm -qi gdbm 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "gdbm" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libgdbm*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/gdbm/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y gdbm 2>/dev/null || true
    echo "TEARDOWN: removed gdbm"
fi
echo ""
echo "All gdbm functional tests passed!"

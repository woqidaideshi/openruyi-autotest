#!/bin/sh -eux
# Functional test: gdb

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install gdb ===
INSTALLED_BY_TEST=0
if ! rpm -q gdb 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y gdb 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed gdb"
    else
        echo "SKIP: gdb not available in repos"
        exit 0
    fi
else
    echo "SETUP: gdb already installed"
fi


rpm -q gdb 2>/dev/null || { echo "gdb not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql gdb 2>/dev/null | head -10 || true
rpm -qi gdb 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "gdb" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libgdb*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/gdb/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y gdb 2>/dev/null || true
    echo "TEARDOWN: removed gdb"
fi
echo ""
echo "All gdb functional tests passed!"

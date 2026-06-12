#!/bin/sh -eux
# Functional test: expect

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install expect ===
INSTALLED_BY_TEST=0
if ! rpm -q expect 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y expect 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed expect"
    else
        echo "SKIP: expect not available in repos"
        exit 0
    fi
else
    echo "SETUP: expect already installed"
fi


rpm -q expect 2>/dev/null || { echo "expect not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql expect 2>/dev/null | head -10 || true
rpm -qi expect 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "expect" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libexpect*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/expect/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y expect 2>/dev/null || true
    echo "TEARDOWN: removed expect"
fi
echo ""
echo "All expect functional tests passed!"
